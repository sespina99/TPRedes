variable "vpc_id" {
  type        = string
  description = "value of the vpc id"
}

variable "instance_ids" {
    type = list(string)
    description = "value of the instance ids"
}

variable "subnet_ids" {
  type        = list(string)
  description = "value of the subnet ids"
}