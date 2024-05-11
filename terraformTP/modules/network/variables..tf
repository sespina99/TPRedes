variable "vpc_name" {
  description = "VPC Name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
}

variable "vpc_azs" {
  description = "List of AZs the VPC lives in"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
  default     = []
}

variable "vpc_private_subnet_names" {
  description = "List of private subnet names"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_service_names" {
  description = "VPC Endpoint Service Names"
  type        = list(string)
  default = []
}

variable "vpc_endpoint_lamda_security_group" {
  description = "List of private subnet CIDR blocks of lambda"
  type        = string
  default = "0"
}
variable "vpc_private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "nat_gateway" {
  type        = bool
  description = "Set to TRUE to enable NAT Gateway Creation"
  default     = false
}