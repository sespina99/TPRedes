output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_a_subnet_id" {
  description = "The ID of the public subnet in AZ us-east-1a"
  value       = aws_subnet.public_a.id
}

output "private_a_subnet_id" {
  description = "The ID of the private subnet in AZ us-east-1a"
  value       = aws_subnet.private_a.id
}

output "public_b_subnet_id" {
  description = "The ID of the public subnet in AZ us-east-1b"
  value       = aws_subnet.public_b.id
}

output "private_b_subnet_id" {
  description = "The ID of the private subnet in AZ us-east-1b"
  value       = aws_subnet.private_b.id
}
