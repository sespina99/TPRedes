locals {
  private_subnet_count = length(var.private_subnet_cidrs)
  public_subnet_count  = length(var.public_subnet_cidrs)
}