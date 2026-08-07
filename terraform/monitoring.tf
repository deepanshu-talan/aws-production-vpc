# Fires when average CPU on the ASG exceeds var.cpu_alarm_threshold
# for two consecutive 5-minute periods.

# Memory and disk metrics are published by the CloudWatch Agent
# installed on each instance via user_data.sh.


resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_alarm_threshold
  alarm_description   = "CPU above ${var.cpu_alarm_threshold}% for ${var.project_name} ASG"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }

  tags = {
    Name = "${var.project_name}-cpu-alarm"
  }
}
