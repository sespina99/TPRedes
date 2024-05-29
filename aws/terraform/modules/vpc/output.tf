output "tags" {
  description = "The name of the vpc"
  value       = aws_vpc.main.tags
}

output "vpc_id" {
  description = "Id of the vpc"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public_subnets[*].id
}