output "private_subnets" {
  value = module.vpc.private_subnet_ids
}

output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

output "ec2_instances" {
  value = module.ec2.instance_ids
}