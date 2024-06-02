output "name" {
  description = "The name of the vpc"
  value       = huaweicloud_vpc.this.name
}

output "vpc_id" {
  description = "Id of the vpc"
  value       = huaweicloud_vpc.this.id
}

output "subnets_ids" {
  description = "Information about the private subnets"
  value       = huaweicloud_vpc_subnet.subnet[*].id
}

output "ipv4_subnet_ids" {
  description = "value"
  value       = huaweicloud_vpc_subnet.subnet[*].ipv4_subnet_id
}

output "elb_subnet_id" {
  description = "The id of the elb subnet"
  value       = huaweicloud_vpc_subnet.elb_subnet.id
}

output "elb_subnet_ipv4_id" {
  description = "The id of the elb subnet ipv4"
  value       = huaweicloud_vpc_subnet.elb_subnet.ipv4_subnet_id
}