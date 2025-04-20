# Scale out Policy
resource "aws_autoscaling_policy" "scale_out_on_requests" {
  name                   = "backASG-scale-out-on-requests"
  autoscaling_group_name = aws_autoscaling_group.myASG.name 
  adjustment_type        = "ChangeInCapacity"             
  scaling_adjustment     = 1                              
  cooldown               = 180                            
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "high_request_count_alarm" {
  alarm_name          = "backASG-high-request-count-alarm" 
  comparison_operator = "GreaterThanOrEqualToThreshold" 
  evaluation_periods  = "3"                             
  metric_name         = "RequestCountPerTarget"         
  namespace           = "AWS/ApplicationELB"            
  period              = "60" # 5초 마다 확인                            
  statistic           = "Sum"                           
  threshold           = "1000" # 요청이 7번 일시 경고                          

  dimensions = {
    LoadBalancer = aws_alb.myALB.arn_suffix            
    TargetGroup  = aws_alb_target_group.myTG.arn_suffix 
  }

  alarm_description = "Scale out if RequestCountPerTarget >= 1000 for 3 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_out_on_requests.arn] 
}

# Scale In Policy
resource "aws_autoscaling_policy" "scale_in_on_requests" {
  name                   = "backASG-scale-in-on-requests"
  autoscaling_group_name = aws_autoscaling_group.myASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1 
  cooldown               = 300 
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "low_request_count_alarm" {
  alarm_name          = "backASG-low-request-count-alarm"
  comparison_operator = "LessThanOrEqualToThreshold" 
  evaluation_periods  = "10"                         
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "300"                          

  dimensions = {
    LoadBalancer = aws_alb.myALB.arn_suffix
    TargetGroup  = aws_alb_target_group.myTG.arn_suffix
  }

  alarm_description = "Scale in if RequestCountPerTarget <= 300 for 10 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_in_on_requests.arn] 
}