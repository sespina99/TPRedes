terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = ">= 1.20.0"
    }
  }
}

resource "huaweicloud_compute_instance" "main" {
  count              = length(var.subnet_ids)
  name               = "terraform-demo-${count.index}"
  image_id           = local.image_id
  flavor_id          = "s6.large.2"
  availability_zone  = local.azs[count.index]
  security_group_ids = [data.huaweicloud_networking_secgroup.mysecgroup.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "<html><body><h1>Hello from Terraform! ${count.index}</h1></body></html>" > index.html
              cp index.html /var/www/html
            EOF
  network {
    uuid = var.subnet_ids[count.index]
  }
}