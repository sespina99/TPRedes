variable "image_id" {
  description = "The ID of the AMI to use for the instance"
  type        = string
  default     = "ami-00c39f71452c08778"
}

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "The number of instances the ASG should have"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of instances the ASG can scale up to"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of instances the ASG can scale down to"
  type        = number
  default     = 1
}

variable "subnet_public_a_id" {
  description = "ID de la subnet pública A"
  type        = string
}

variable "subnet_public_b_id" {
  description = "ID de la subnet pública B"
  type        = string
}

variable "subnet_private_a_id" {
  description = "ID de la subnet privada A"
  type        = string
}

variable "subnet_private_b_id" {
  description = "ID de la subnet privada B"
  type        = string
}

variable "lb_target_group_arn" {
  description = "ARN del target group del Load Balancer"
  type        = string
}

variable "security_group_id" {
  description = "ID del security group para la instancia EC2"
  type        = string
}