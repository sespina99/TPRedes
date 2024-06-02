output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets_ids" {
  value = module.vpc.subnets_ids
}

output "subnets_ipv4_ids" {
  value = module.vpc.ipv4_subnet_ids[*]
}

output "ecs_ids" {
  value = module.ecs.ecs_ids[*]
}

output "ecs_ips" {
  value = module.ecs.ecs_ips
}