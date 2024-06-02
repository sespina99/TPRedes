variable "subnet_ids" {
  description = "List of subnet IDs where the EC2 instances will be created"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = "ami-0bb84b8ffd87024d8"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
  default     = "t2.micro"
}
variable "security_groups" {
  description = "List of security group IDs for the EC2 instances"
  type        = list(string)
}