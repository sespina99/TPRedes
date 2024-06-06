variable "vpc_id" {
  description = "ID de la VPC"
}

variable "internet_gateway_id" {
  description = "ID del Internet Gateway"
}

variable "public_subnet_a_id" {
  description = "ID de la subred pública A"
}

variable "public_subnet_b_id" {
  description = "ID de la subred pública B"
}

variable "private_subnet_a_id" {
  description = "ID de la subred privada A"
}

variable "private_subnet_b_id" {
  description = "ID de la subred privada B"
}

variable "nat_gateway_a_id" {
  description = "ID del NAT Gateway A"
}

variable "nat_gateway_b_id" {
  description = "ID del NAT Gateway B"
}
