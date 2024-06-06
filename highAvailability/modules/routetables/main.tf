
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = var.public_subnet_a_id
  route_table_id = aws_route_table.public.id
}

# Asociación de tabla de enrutamiento para la subred pública B
resource "aws_route_table_association" "public_b" {
  subnet_id      = var.public_subnet_b_id
  route_table_id = aws_route_table.public.id
}

# Tabla de enrutamiento para subredes privadas
resource "aws_route_table" "private_a" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_a_id
  }
}

# Asociación de tabla de enrutamiento para la subred privada A
resource "aws_route_table_association" "private_a" {
  subnet_id      = var.private_subnet_a_id
  route_table_id = aws_route_table.private_a.id
}

# Tabla de enrutamiento para subredes privadas
resource "aws_route_table" "private_b" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_b_id
  }
}

# Asociación de tabla de enrutamiento para la subred privada B
resource "aws_route_table_association" "private_b" {
  subnet_id      = var.private_subnet_b_id
  route_table_id = aws_route_table.private_b.id
}
