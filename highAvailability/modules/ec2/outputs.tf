output "launch_template_id" {
  description = "The ID of the launch template"
  value       = aws_launch_template.redes_launches.id
}

output "autoscaling_group_id" {
  description = "The ID of the autoscaling group"
  value       = aws_autoscaling_group.redes_asg.id
}
