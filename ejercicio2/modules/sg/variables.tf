variable "sg_ports_for_internet" {
  description = "Ports for the security group for ELB"
  type        = list(number)
  default     = [80, 443]
}

variable "vpc_id" {
  description = "ID de la VPC"
}