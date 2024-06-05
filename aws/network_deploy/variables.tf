variable "aws_region" {
  type        = string
  description = "AWS Region in which to deploy the application"
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "Name of the main vpc of the aplication"
  default     = "main-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block for the main vpc of the application"
}

variable "az_list" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["us-east-1a", "us-east-1b"] 
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = [ "10.0.1.0/24", "10.0.2.0/24"]
}