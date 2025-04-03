###############################
# Target Group 생성
resource "aws_alb_target_group" "myTG" {
  vpc_id = var.vpc_id 
  port = 8080 ## 로드밸런서 8080포트로 접속시 타겟 8080포트로 연결
  protocol = "HTTP"
  name = "backend-alb-tg"
  health_check {
    path                = "/home"   # 헬스체크 경로
    interval            = 10                   # 검사 주기 (초)
    timeout             = 5                    # 타임아웃 (초)
    healthy_threshold   = 2                    # 몇 번 연속 성공하면 "Healthy"
    unhealthy_threshold = 2                    # 몇 번 연속 실패하면 "Unhealthy"
    matcher             = "200-399"            # 응답 코드 범위
  }
  
}
##############################
# ALB 생성
resource "aws_alb" "myALB" {
  name = "backend-alb"
  load_balancer_type = "application"
  internal = true  
  security_groups = [ var.security_group_id ]
  subnets = var.private_subnet_id
}
#######################################
# ALB listener 생성
resource "aws_alb_listener" "ALB_listener" {
  load_balancer_arn = aws_alb.myALB.arn 
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.myTG.arn 
  }
}
#######################################
# 시작템플릿 생성
resource "aws_launch_template" "back_launch_template" {
  name = "back_launch_template"
  image_id = "ami-075e056c0f3d02523"
  instance_type = "t2.micro"
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    DB_DNS=var.db_dns
    front_DNS=var.front_dns
  }))
  vpc_security_group_ids = [ var.security_group_id ]
  iam_instance_profile {
    arn = var.iam_role_profile_arn
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "springboot"
    }
  }
}
######################################
# AutoScalingGroup 생성 및 연결
resource "aws_autoscaling_group" "myASG" {
  name = "backASG"
  min_size = 1
  max_size = 5
  desired_capacity = 1
  health_check_grace_period = 30 
  health_check_type = "EC2"
  force_delete = false
  vpc_zone_identifier = var.private_subnet_id
  launch_template {
    id = aws_launch_template.back_launch_template.id 
    version = "$Latest"
  }
  depends_on = [ var.db_instance ]
}
resource "aws_autoscaling_attachment" "myASG_attachment" {
  autoscaling_group_name = aws_autoscaling_group.myASG.id 
  lb_target_group_arn = aws_alb_target_group.myTG.arn
}
####################
## Code Deploy
resource "aws_codedeploy_deployment_group" "springboot_dg" {
  app_name              = aws_codedeploy_app.springboot_app.name
  deployment_group_name = "springboot-dg"
  service_role_arn      = var.iam_code_deploy_arn


  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
  
  autoscaling_groups = [ aws_autoscaling_group.myASG.name ]

  load_balancer_info {
    target_group_info {
      name = aws_alb_target_group.myTG.name
    }
  }
  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = "springboot"
  }
}
resource "aws_codedeploy_app" "springboot_app" {
  name = "springboot-app"
  compute_platform = "Server"
}
