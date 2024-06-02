data "huaweicloud_availability_zones" "available" {
  region = var.region
  state  = "available"
}

locals {
  availability_zones = data.huaweicloud_availability_zones.available.names
  zones_count        = length(data.huaweicloud_availability_zones.available.names)
}