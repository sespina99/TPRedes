resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
}

resource "aws_eip" "redes_eip_a" {
  depends_on = [aws_internet_gateway.gw]
  domain     = "vpc"
  tags = {
    Name = "eip_for_NAT_a"
  }
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.redes_eip_a.id
  subnet_id     = var.subnet_public_a_id

  tags = {
    Name = "nat_for_private_subnet_a"
  }
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_eip" "redes_eip_b" {
  depends_on = [aws_internet_gateway.gw]
  domain     = "vpc"
  tags = {
    Name = "eip_for_NAT_b"
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.redes_eip_b.id
  subnet_id     = var.subnet_public_b_id

  tags = {
    Name = "nat_for_private_subnet_b"
  }
  depends_on = [aws_internet_gateway.gw]
}