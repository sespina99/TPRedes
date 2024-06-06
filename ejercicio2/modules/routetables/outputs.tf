output "public_route_table_id" {
  description = "ID de la tabla de enrutamiento para subredes públicas"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID de la tabla de enrutamiento para subredes privadas"
  value       = aws_route_table.private_a.id
}
