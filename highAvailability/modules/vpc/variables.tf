variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_a_cidr" {
  description = "The CIDR block for the public subnet in AZ us-east-1a"
  default     = "10.0.1.0/24"
}

variable "private_a_cidr" {
  description = "The CIDR block for the private subnet in AZ us-east-1a"
  default     = "10.0.2.0/24"
}

variable "public_b_cidr" {
  description = "The CIDR block for the public subnet in AZ us-east-1b"
  default     = "10.0.3.0/24"
}

variable "private_b_cidr" {
  description = "The CIDR block for the private subnet in AZ us-east-1b"
  default     = "10.0.4.0/24"
}
