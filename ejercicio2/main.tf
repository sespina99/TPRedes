terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

module "vpc" {
  source = "./modules/vpc"

  vpc_name = "VPC-Redes"
}

module "gateways" {
  source             = "./modules/gateways"
  vpc_id             = module.vpc.vpc_id
  subnet_public_a_id = module.vpc.public_a_subnet_id
  subnet_public_b_id = module.vpc.public_b_subnet_id
}

module "routetables" {
  source = "./modules/routetables"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.gateways.internet_gateway_id
  nat_gateway_a_id    = module.gateways.nat_gateway_a_id
  nat_gateway_b_id    = module.gateways.nat_gateway_b_id
  public_subnet_a_id  = module.vpc.public_a_subnet_id
  public_subnet_b_id  = module.vpc.public_b_subnet_id
  private_subnet_a_id = module.vpc.private_a_subnet_id
  private_subnet_b_id = module.vpc.private_b_subnet_id
}

module "security_groups" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"

  internet_gateway_id = module.gateways.internet_gateway_id
  subnet_public_a_id  = module.vpc.public_a_subnet_id
  subnet_public_b_id  = module.vpc.public_b_subnet_id
  vpc_id              = module.vpc.vpc_id
  security_group_id   = module.security_groups.sg_for_elb_id
}

module "ec2" {
  source = "./modules/ec2"

  subnet_public_a_id  = module.vpc.public_a_subnet_id
  subnet_public_b_id  = module.vpc.public_b_subnet_id
  subnet_private_a_id = module.vpc.private_a_subnet_id
  subnet_private_b_id = module.vpc.private_b_subnet_id
  security_group_id   = module.security_groups.sg_for_ec2_id
  lb_target_group_arn = module.alb.lb_target_group_arn
}










