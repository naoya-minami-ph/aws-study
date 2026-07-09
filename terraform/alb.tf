resource "aws_lb" "main" {
  name               = "aws-study-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_1a.id, aws_subnet.public_1c.id]

  tags = {
    Name = "aws-study-elb"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "aws-study-elb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    interval            = 10
    matcher             = "200"
  }

  tags = {
    Name = "aws-study-elb-target-group"
  }
}

resource "aws_lb_target_group_attachment" "ec2" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.main.id
  port              = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
