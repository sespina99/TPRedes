variable "huawei_region" {
  description = "The region where the resources will be created"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "access_key" {
  description = "The access key of the Huawei Cloud account"
  type        = string
}

variable "secret_key" {
  description = "The secret key of the Huawei Cloud account"
  type        = string
}