output "lb_arn" {
  description = "The ARN of the Load Balancer"
  value       = aws_lb.redes_albalancer.arn
}

output "lb_target_group_arn" {
  description = "The ARN of the Load Balancer Target Group"
  value       = aws_lb_target_group.alb_target_groups.arn
}

output "lb_listener_arn" {
  description = "The ARN of the Load Balancer Listener"
  value       = aws_lb_listener.listener.arn
}