variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "security_group_id" {
  description = "ID del security group para el ELB"
  type        = string
}

variable "internet_gateway_id" {
  description = "ID del Internet Gateway"
  type        = string
}

variable "subnet_public_a_id" {
  description = "ID de la subnet pública A"
  type        = string
}

variable "subnet_public_b_id" {
  description = "ID de la subnet pública B"
  type        = string
}
