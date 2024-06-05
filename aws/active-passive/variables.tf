variable "aws_region" {
  type        = string
  description = "AWS Region in which to deploy the application"
}

variable "vpc_name" {
  type        = string
  description = "Name of the main vpc of the aplication"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block for the main vpc of the application"
}

variable "domain_name" {
  description = "Domain name registered for Application"
}

variable "ttl" {
  description = "TTL of Record"
}

variable "primaryhealthcheck" {
  description = "Tag Name for Primary Instance Health Check"
}

variable "secondaryhealthcheck" {
  description = "Tag Name for Secondary Instance Health Check"
}

variable "subdomain" {
  description = "Sub Domain name to access Application"
}

variable "identifier1" {
  default = "primary"
}

variable "identifier2" {
  default = "secondary"
}