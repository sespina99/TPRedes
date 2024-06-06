module "vpc" {
  source     = "../modules/vpc"
  name       = var.vpc_name
  cidr_block = var.cidr_block
  region     = var.huawei_region
}