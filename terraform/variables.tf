variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
  default     = "175.176.67.202"
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
