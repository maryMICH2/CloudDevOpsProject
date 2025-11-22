# SNS Topic (for email alerts)
 resource "aws_sns_topic" "alerts_topic" {
  name = "${var.name}-alerts-topic"
}

 # SNS Email Subscription
 resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

 # CloudWatch Alarm for Jenkins Master
 resource "aws_cloudwatch_metric_alarm" "jenkins_master_cpu" {
  alarm_name                = "${var.name}-jenkins-master-high-cpu"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 70
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    InstanceId = var.jenkins_master_id
  }
}

 # CloudWatch Alarm for Jenkins Worker
 resource "aws_cloudwatch_metric_alarm" "jenkins_worker_cpu" {
  alarm_name                = "${var.name}-jenkins-worker-high-cpu"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = 70
  alarm_actions             = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    InstanceId = var.jenkins_worker_id
  }
}
