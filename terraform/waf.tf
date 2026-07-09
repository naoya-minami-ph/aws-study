resource "aws_wafv2_web_acl" "main" {
  name  = "aws-study-webacl"
  scope = "REGIONAL" # ALBは必ずREGIONAL

  default_action {
    allow {}
  }

  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "aws-study-webacl"
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "commonRules"
    }
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.main.arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# CloudWatch Logs ロググループ（WAFログ出力先）
resource "aws_cloudwatch_log_group" "waf" {
  name              = "aws-waf-logs-aws-study" # WAFv2のログ送信先は "aws-waf-logs-" で始まる必要がある
  retention_in_days = 90
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  resource_arn            = aws_wafv2_web_acl.main.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf.arn]
}

# WAFブロック数アラーム（CloudWatchアラームだが、WAF本体に依存するためここに記載）
resource "aws_cloudwatch_metric_alarm" "waf_blocked" {
  alarm_name          = "aws-study-waf-blocked-requests-alarm"
  alarm_description   = "WAFが10件以上のリクエストをブロックしました"
  namespace           = "AWS/WAFV2"
  metric_name         = "BlockedRequests"
  dimensions = {
    WebACL = aws_wafv2_web_acl.main.name
    Region = var.aws_region
    Rule   = "ALL"
  }
  statistic           = "Sum"
  period              = 300
  threshold           = 10
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  treat_missing_data  = "notBreaching"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alarm.arn]
}
