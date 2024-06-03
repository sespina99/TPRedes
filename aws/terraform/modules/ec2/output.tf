output "instance_ids" {
  value = aws_instance.web[*].id
}

output "public_ip_primary" {
  value = aws_eip.this[0].public_ip
}

output "public_ip_secondary" {
  value = aws_eip.this[1].public_ip
}

output "public_dns" {
  value = aws_instance.web[*].public_dns
}