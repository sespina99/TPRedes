variable "cidr_block" {
  type        = string
  description = "CIDR block for the vpc"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "name_tag" {
  type        = string
  description = "value of the name tag"
  default     = "redes-demo"
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = []
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
}