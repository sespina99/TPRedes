module "vpc" {
  source = "../modules/vpc"

  cidr_block = var.vpc_cidr_block
  vpc_name   = var.vpc_name

  azs                  = ["us-east-1a", "us-east-1b"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  public_subnet_cidrs  = []
}

module "ec2" {
  source = "../modules/ec2"

  subnet_ids = module.vpc.private_subnet_ids
}

module "alb" {
  source = "../modules/alb"

  subnet_ids = module.vpc.private_subnet_ids
  instance_ids = module.ec2.instance_ids
  vpc_id     = module.vpc.vpc_id
}