output "alb_dns_name" {
  description = "ALBのDNS名（ブラウザでアクセス確認用）"
  value       = aws_lb.main.dns_name
}

output "ec2_instance_id" {
  value = aws_instance.main.id
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}
