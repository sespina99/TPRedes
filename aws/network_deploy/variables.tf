variable "aws_region" {
  type        = string
  description = "AWS Region in which to deploy the application"
}

variable "vpc_name" {
  type        = string
  description = "Name of the main vpc of the aplication"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block for the main vpc of the application"
}

variable "az_list" {
  type        = list(string)
  description = "List of availability zones"
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}