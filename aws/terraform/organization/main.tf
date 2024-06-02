module "vpc_1" {
  source = "../modules/vpc"

  cidr_block = "20.0.0.0/16"
  vpc_name   = "active-vpc"

  azs                  = ["us-east-1a"]
  private_subnet_cidrs = []
  public_subnet_cidrs  = ["20.0.20.0/24"]
}

module "vpc_2" {
  source = "../modules/vpc"

  cidr_block = "10.0.0.0/16"
  vpc_name   = "passive-vpc"

  azs                  = ["us-east-1b"]
  private_subnet_cidrs = []
  public_subnet_cidrs  = ["10.0.10.0/24"]
}

module "ec2_active" {
  source = "../modules/ec2"

  subnet_ids = module.vpc_1.public_subnet_ids

  security_groups = []
}

module "ec2_passive" {
  source = "../modules/ec2"

  subnet_ids = module.vpc_2.public_subnet_ids

  security_groups = []
  
}

module "route53" {
  source = "../modules/route53"

  domain_name          = var.domain_name
  ttl                  = var.ttl
  primaryhealthcheck   = var.primaryhealthcheck
  secondaryhealthcheck = var.secondaryhealthcheck
  subdomain            = var.subdomain
  identifier1          = var.identifier1
  identifier2          = var.identifier2
  primaryip            = module.ec2_active.public_ips[0]
  secondaryip          = module.ec2_passive.public_ips[0]
}