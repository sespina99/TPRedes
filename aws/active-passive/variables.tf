variable "aws_region" {
  type        = string
  description = "AWS Region in which to deploy the application"
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "Name of the main vpc of the aplication"
  default     = "main-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "cidr block for the main vpc of the application"
  default     = "10.0.0.0/16"
}

variable "domain_name" {
  description = "Domain name registered for Application"
  default     = "tech-demo.tech"
}

variable "ttl" {
  description = "TTL of Record"
  default     = "10"
}

variable "primaryhealthcheck" {
  description = "Tag Name for Primary Instance Health Check"
  default     = "route53-primary-health-check"
}

variable "secondaryhealthcheck" {
  description = "Tag Name for Secondary Instance Health Check"
  default     = "route53-secondary-health-check"
}

variable "subdomain" {
  description = "Sub Domain name to access Application"
  default     = "www.tech-demo.tech"
}

variable "identifier1" {
  default = "primary"
}

variable "identifier2" {
  default = "secondary"
}