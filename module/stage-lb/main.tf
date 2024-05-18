# Creating stage target group
resource "aws_lb_target_group" "stage-tg" {
  name     = "stage-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 5
  }
}

# Creating stage application load balancer
resource "aws_lb" "stage-lb" {
  name                       = "stage-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.stage-sg
  subnets                    = var.stage-subnet
  enable_deletion_protection = false

  tags = {
    Name = var.stage-lb
  }
}

# Creating application load balancer listener for HTTP
resource "aws_lb_listener" "stage-listener-http" {
  load_balancer_arn = aws_lb.stage-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-tg.arn
  }
}

# Creating application load balancer listener for HTTPS
resource "aws_lb_listener" "stage-listener-https" {
  load_balancer_arn = aws_lb.stage-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.stage-tg.arn
  }
}
