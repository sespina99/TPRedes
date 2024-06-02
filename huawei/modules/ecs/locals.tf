data "huaweicloud_availability_zones" "myaz" {

}

data "huaweicloud_networking_secgroup" "mysecgroup" {
  name = "Sys-WebServer"
}

data "huaweicloud_images_image" "myimage" {
  name = "Ubuntu 22.04 server 64bit"
}

locals {
  azs               = data.huaweicloud_availability_zones.myaz.names
  image_id          = "a7639c6f-ac0a-4f82-b2e4-c514cb934de8"
  security_group_id = data.huaweicloud_networking_secgroup.mysecgroup.id
}