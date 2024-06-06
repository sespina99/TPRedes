output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.gw.id
}

output "nat_gateway_public_ips" {
  value = [
    aws_eip.redes_eip_a.public_ip,
    aws_eip.redes_eip_b.public_ip
  ]
  description = "Public IPs of the NAT gateways"
}

output "nat_gateway_a_id" {
  value       = aws_nat_gateway.nat_a.id
  description = "IDs of the NAT gateways"
}

output "nat_gateway_b_id" {
  value       = aws_nat_gateway.nat_b.id
  description = "IDs of the NAT gateways"
}
