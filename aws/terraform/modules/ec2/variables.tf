variable "subnet_ids" {
  description = "List of subnet IDs where the EC2 instances will be created"
  type        = list(string)
}
variable "security_groups" {
  description = "List of security group IDs for the EC2 instances"
  type        = list(string)
}