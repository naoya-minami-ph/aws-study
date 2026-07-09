variable "my_ip" {
  description = "Your IP address for SSH access (e.g. 203.0.113.1). No default is set intentionally; specify your own value in terraform.tfvars."
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true # CFnのNoEcho: trueに相当
}

variable "notification_email" {
  description = "Email address for alarm notifications"
  type        = string
}

variable "aws_region" {
  description = "Deploy region"
  type        = string
  default     = "ap-northeast-1"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "nan.tt0105"
}
