resource "aws_sns_topic" "alarm" {
  name = "aws-study-alarm-topic"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {
  alarm_name          = "aws-study-cpu-utilization-alarm"
  alarm_description   = "aws-study-ec2 のCPU使用率が5%以上になりました"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  dimensions = {
    InstanceId = aws_instance.main.id
  }
  unit                = "Percent"
  period              = 300
  statistic           = "Average"
  threshold           = 5
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  datapoints_to_alarm = 2
  treat_missing_data  = "missing"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarm.arn]
}

# ---------------------------------------------------------
# 注意: WAFブロック数のアラームはWAF本体(aws_wafv2_web_acl)を
# 参照するため、waf.tf側にまとめて記載している。
# （このファイルの段階ではまだWAFが存在しないため）
# ---------------------------------------------------------
