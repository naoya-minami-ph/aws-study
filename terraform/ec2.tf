resource "aws_instance" "main" {
  ami                                   = data.aws_ssm_parameter.al2023_ami.value
  instance_type                        = "t3.micro"
  subnet_id                            = aws_subnet.public_1a.id
  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "stop"
  key_name                             = var.key_name
  monitoring                           = false
  vpc_security_group_ids               = [aws_security_group.ec2.id]

  tags = {
    Name = "aws-study-ec2"
  }
}
