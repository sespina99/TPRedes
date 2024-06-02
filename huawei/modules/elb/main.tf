terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.20.0"
    }
  }
}

resource "huaweicloud_elb_loadbalancer" "main" {
  name              = "terraform-elb"
  description       = "terraform demo"
  cross_vpc_backend = false

  backend_subnets = var.backend_subnets_ids

  vpc_id = var.vpc_id

  availability_zone = local.az_names

  iptype                = "5_bgp"
  bandwidth_charge_mode = "traffic"
  sharetype             = "PER"
  bandwidth_size        = 10
}

resource "huaweicloud_elb_listener" "basic" {
  name            = "basic"
  description     = "basic description"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = huaweicloud_elb_loadbalancer.main.id
  default_pool_id = huaweicloud_elb_pool.backend_server_group.id

  idle_timeout     = 60
  request_timeout  = 60
  response_timeout = 60

  tags = {
    key = "terraform"
  }
}

resource "huaweicloud_elb_l7policy" "this" {
  name             = "policy"
  action           = "REDIRECT_TO_POOL"
  listener_id      = huaweicloud_elb_listener.basic.id
  redirect_pool_id = huaweicloud_elb_pool.backend_server_group.id
}

resource "huaweicloud_elb_pool" "backend_server_group" {
  name            = "terraform-demo-pool"
  protocol        = "HTTP"
  lb_method       = "ROUND_ROBIN"
  type            = "instance"
  vpc_id          = var.vpc_id
  loadbalancer_id = huaweicloud_elb_loadbalancer.main.id

  slow_start_enabled = false

}

resource "huaweicloud_elb_member" "this" {
  count         = length(var.ecs_machines_id)
  address       = var.ecs_ipv4_list[count.index]
  protocol_port = 80
  pool_id       = huaweicloud_elb_pool.backend_server_group.id
  subnet_id     = var.ipv4_subnet_ids[count.index]
}