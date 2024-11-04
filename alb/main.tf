resource "aws_lb" "this" {
  count               = var.create ? 1 : 0
  name                = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups     = var.security_group_ids
  subnets            = var.subnets

  enable_deletion_protection = false
  idle_timeout               = 60
  tags                       = var.tags
}

# Define the target group based on the input variables
resource "aws_lb_target_group" "this" {
  count = var.target_group_count

  name     = "${var.load_balancer_name}-tg-${count.index}"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  # Optionally reference the ARN
  target_group_arn = var.target_group_arn

  # Health check settings
  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold  = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
}

# Other resources like listeners can be added here...
