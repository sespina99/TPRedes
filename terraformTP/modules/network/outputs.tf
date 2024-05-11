output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets_ids_by_cidr" {
  description = "Private subnets ids by cidr block"
  value       = { for i in range(length(module.vpc.private_subnets)) : module.vpc.private_subnets_cidr_blocks[i] => module.vpc.private_subnets[i] }
}

output "vpc_endpoints" {
  description = "Networking VPC Endpoints"
  value = { 
    for i in range(length(aws_vpc_endpoint.this)) : aws_vpc_endpoint.this[i].service_name =>
    {
      id = aws_vpc_endpoint.this[i].id,
      cidr_blocks = aws_vpc_endpoint.this[i].cidr_blocks
    }
  }
}

output "vpc_endpoints_info" {
  value = module.vpc
}

output "sns_endpoint_network_interface_ids" {
  value = aws_vpc_endpoint.sns.network_interface_ids
}

output "vpc_endpoint_id" {
  value = aws_vpc_endpoint.sns.dns_entry[0].dns_name
}