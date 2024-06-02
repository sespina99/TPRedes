terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.20.0"
    }
  }
}

resource "huaweicloud_vpc" "this" {
  name   = var.name
  region = var.region
  cidr   = var.cidr_block
}

resource "huaweicloud_vpc_subnet" "subnet" {
  count             = local.zones_count
  name              = "subnet-${count.index}"
  cidr              = cidrsubnet(var.cidr_block, 8, count.index)
  gateway_ip        = cidrhost(cidrsubnet(var.cidr_block, 8, count.index), 1)
  vpc_id            = huaweicloud_vpc.this.id
  availability_zone = data.huaweicloud_availability_zones.available.names[count.index]
}

resource "huaweicloud_vpc_subnet" "elb_subnet" {
  name              = "elb-subnet"
  cidr              = cidrsubnet(var.cidr_block, 8, 2)
  gateway_ip        = cidrhost(cidrsubnet(var.cidr_block, 8, 2), 1)
  vpc_id            = huaweicloud_vpc.this.id
  availability_zone = data.huaweicloud_availability_zones.available.names[0]
}