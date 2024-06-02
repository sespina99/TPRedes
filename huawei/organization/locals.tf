locals {
  vpc           = var.vpc_name
  cidr_block    = "10.0.0.0/16"
  region        = var.huawei_region
  access_key_id = var.huawei_access_key_id
  secret_key    = var.huawei_secret_key
}