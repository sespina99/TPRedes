module "vpc" {
  source = "../modules/vpc"

  cidr_block = var.vpc_cidr_block
  vpc_name   = var.vpc_name

  azs                  = var.az_list
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
}