variable "vpc_name" {
  type        = string
  description = "Name of the main vpc of the aplication"
  default     = "huawei-terraform-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block for the main vpc of the application"
}

variable "huawei_region" {
  type        = string
  description = "Huawei region in which to deploy the resources"
  default     = "la-south-2"
}

variable "huawei_access_key_id" {
  type        = string
  description = "Huawei access key id credentials"
}

variable "huawei_secret_key" {
  type        = string
  description = "Huawei secret key credentials"
}