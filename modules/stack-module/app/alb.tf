module "app_alb_security_group" {
  source = "../../modules/security-group"

  description   = "App ALB security group"
  name          = "${var.environment}-app"
  vpc_id        = var.vpc_id
  allowed_ip    = ["75.2.60.0/24"]
  allowed_ports = [8080]
}

resource "aws_lb" "app" {
  name                       = "${var.environment}-app"
  desync_mitigation_mode     = "monitor"
  enable_deletion_protection = true
  idle_timeout               = 1200
  internal                   = "false"
  load_balancer_type         = "application"
  security_groups            = [module.app_alb_security_group.sg_id]
  subnets                    = var.public_subnets
}


resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}


resource "aws_lb_target_group" "app" {
  name        = "${var.environment}-app"
  port        = var.ecs.host_port
  protocol    = "HTTP"
  target_type = "ip"
  slow_start  = 30
  vpc_id      = var.vpc_id
  deregistration_delay = 90
  health_check {
    path                = "/"
    interval            = 30
    unhealthy_threshold = 4
    healthy_threshold   = 2
  }
}