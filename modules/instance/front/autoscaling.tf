# Scale out Policy
resource "aws_autoscaling_policy" "scale_out_on_requests" {
  name                   = "frontASG-scale-out-on-requests"
  autoscaling_group_name = aws_autoscaling_group.myASG.name 
  adjustment_type        = "ChangeInCapacity"             
  scaling_adjustment     = 1                              
  cooldown               = 60                            
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "high_request_count_alarm" {
  alarm_name          = "frontASG-high-request-count-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold" 
  evaluation_periods  = "3"                             
  metric_name         = "RequestCountPerTarget"         
  namespace           = "AWS/ApplicationELB"            
  period              = "60"                            
  statistic           = "Sum"                           
  threshold           = "1000"                          

  dimensions = {
    LoadBalancer = aws_alb.myALB.arn_suffix            
    TargetGroup  = aws_alb_target_group.myTG.arn_suffix 
  }

  alarm_description = "Scale out if RequestCountPerTarget >= 1000 for 3 minutes"
  alarm_actions     = [aws_autoscaling_policy.scale_out_on_requests.arn] 
}

# Scale In Policy
resource "aws_autoscaling_policy" "scale_in_on_requests" {
  name                   = "frontASG-scale-in-on-requests"
  autoscaling_group_name = aws_autoscaling_group.myASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1 
  cooldown               = 300 
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "low_request_count_alarm" {
  alarm_name          = "frontASG-low-request-count-alarm"
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