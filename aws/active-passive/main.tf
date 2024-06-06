module "vpc" {
  source = "../modules/vpc"

  cidr_block = "10.0.0.0/16"
  vpc_name   = "active-vpc"

  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnet_cidrs = []
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "ec2" {
  source = "../modules/ec2"

  subnet_ids = module.vpc.public_subnet_ids

  security_groups = [module.vpc.sg_id]
}

module "route53" {
  source = "../modules/route53"

  domain_name          = var.domain_name
  ttl                  = var.ttl
  primaryhealthcheck   = var.primaryhealthcheck
  secondaryhealthcheck = var.secondaryhealthcheck
  identifier1          = var.identifier1
  identifier2          = var.identifier2
  primaryip            = module.ec2.public_ip_primary
  secondaryip          = module.ec2.public_ip_secondary
}