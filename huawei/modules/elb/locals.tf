data "huaweicloud_availability_zones" "available" {
  region = var.region
  state  = "available"
}

locals {
  az_names = data.huaweicloud_availability_zones.available.names
}