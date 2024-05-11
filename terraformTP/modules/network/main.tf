module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnet_cidrs

  private_subnet_names = var.vpc_private_subnet_names

  # enable_nat_gateway  = var.nat_gateway
  # public_subnets      = var.vpc_private_subnet_cidrs
  # public_subnet_names = var.vpc_private_subnet_cidrs
}

resource "aws_vpc_endpoint" "this" {
  count = length(var.vpc_endpoint_service_names)

  vpc_id       = module.vpc.vpc_id
  service_name = var.vpc_endpoint_service_names[count.index]

  route_table_ids = module.vpc.private_route_table_ids
}


resource "aws_vpc_endpoint" "sns" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.us-east-1.sns"
  vpc_endpoint_type = "Interface"

  security_group_ids = [var.vpc_endpoint_lamda_security_group]

  subnet_ids = module.vpc.private_subnets

  private_dns_enabled = true
}

# resource "aws_vpc_endpoint" "this" {
#   provider = aws.aws

#   vpc_id            = module.vpc.vpc_id
#   service_name      = each.value.service
#   vpc_endpoint_type = try(each.value.endpoint_type, "Gateway")
# }
