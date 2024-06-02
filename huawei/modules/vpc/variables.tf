variable "name" {
  type        = string
  description = "Name of the vpc"
}

variable "region" {
  type        = string
  description = "Huawei region in which to deploy the resources"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the vpc"
}