output "load_balancer_arn" {
  value = aws_lb.this[0].arn
}

output "target_group_arns" {
  value = aws_lb_target_group.this[*].arn
}
