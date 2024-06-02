variable "vpc_id" {
  type        = string
  description = "id of the vpc"
}

variable "ecs_machines_id" {
  type        = list(string)
  description = "id of the ecs machines"
}

variable "ecs_ipv4_list" {
  type        = list(string)
  description = "value of the ecs ipv4 list"
}

variable "elb_ipv4_subnet_id" {
  type        = string
  description = "id of the elb ipv4 subnet"
}

variable "backend_subnets_ids" {
  type        = list(string)
  description = "id of the backend subnets"
}

variable "ipv4_subnet_ids" {
  type        = list(string)
  description = "id of the ipv4 subnet"
}

variable "region" {
  type        = string
  description = "Huawei region in which to deploy the resources"
  default     = "la-south-2"
}