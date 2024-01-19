#__________________ ROUTE TABLE______________________________________
#Table de routage pour la subnet
resource "aws_route_table" "public_route_table_amar" {
  vpc_id = var.route_vpc_id
  route {
    cidr_block = var.route_cidr_block
    gateway_id = var.route_table_gateway_id
  }
  tags = {
    Name = var.route_table_name
  }
}

output "route_table_id" {
  value = aws_route_table.public_route_table_amar.id
}