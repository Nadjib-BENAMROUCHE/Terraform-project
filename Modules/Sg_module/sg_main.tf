module "vpc_terraform" {
  source = "../Vpc_module"
}

#___________________Security Group ___________________
resource "aws_security_group" "security_groupe_" {
  name        = var.sg_name
  vpc_id      = var.vpc_id
  ingress {
    from_port   = var.from_port
    to_port     = var.to_port
    protocol    = var.protocol
    cidr_blocks = var.cidr_blocks
  }
  egress {
    from_port   = var.from_port_in
    to_port     = var.to_port_in
    protocol    = var.to_port_in
    cidr_blocks = var.cidr_blocks_in
  }
  tags = {
    Name = var.sg_name
  }
}

output "sg_id" {
  value = aws_security_group.security_groupe_.id
}