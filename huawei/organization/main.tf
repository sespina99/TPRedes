

module "vpc" {
  source = "../modules/vpc"

  name       = local.vpc
  cidr_block = local.cidr_block
  region     = var.huawei_region
}

module "ecs" {
  source = "../modules/ecs"

  subnet_ids = module.vpc.subnets_ids
}

module "elb" {
  source = "../modules/elb"

  vpc_id              = module.vpc.vpc_id
  ecs_machines_id     = module.ecs.ecs_ids
  ecs_ipv4_list       = module.ecs.ecs_ips
  ipv4_subnet_ids     = module.vpc.ipv4_subnet_ids
  backend_subnets_ids = module.vpc.subnets_ids
  elb_ipv4_subnet_id  = module.vpc.elb_subnet_ipv4_id
}