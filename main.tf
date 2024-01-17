provider "aws" {
  region = "eu-west-1"
}
module "vpc_terraform" {
  source = "./Modules/Vpc_module/"
}

#__________________ PRIVATE Subnet___________________________________
module "subnet_private" {
  source           = "./Modules/Subnet_module/"
  cidr_block_value = var.cidr_block_value_private
  subnet_name      = var.subnet_name_private
}
#####################################################################


#__________________ PUBLIC Subnet____________________________________
module "subnet_public" {
  source           = "./Modules/Subnet_module/"
  cidr_block_value = var.cidr_block_value_public
  subnet_name      = var.subnet_name_public
}
#####################################################################

#__________________ Internet Gateway ________________________________
data "aws_internet_gateway" "gateway" {
  filter {
    name   = "attachment.vpc-id"
    values = [module.vpc_terraform.existing_vpc_id]
  }
}
output "internet_gateway_id" {
  value = data.aws_internet_gateway.gateway.id
}
#####################################################################

#__________________ ROUTE TABLE______________________________________
#Table de routage pour la subnet
resource "aws_route_table" "public_route_table_amar" {
  vpc_id = module.vpc_terraform.existing_vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.gateway.id
  }
  tags = {
    Name = "public_route_table_amar"
  }
}
#Association de la table de routage pb au subnet public
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = module.subnet_public.aws_subnet_module_id
  route_table_id = aws_route_table.public_route_table_amar.id
}
#####################################################################







#__________________ PRIVATE EC2_________________
resource "aws_instance" "ec2-amar" {
  ami                    = "ami-0905a3c97561e0b69"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_groupe_public.id]
  subnet_id              = module.subnet_public.aws_subnet_module_id
  #key_name = "shittest"
  tags = {
    Name      = "ec2_public_terraform_amar_henni"
    user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install python3 -y
                EOF
  }
}
data "aws_eip" "by_public_eip" {
  public_ip = "54.154.167.140"
}

output "eip_id" {
  value = data.aws_eip.by_public_eip.id
}
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2-amar.id
  allocation_id = data.aws_eip.by_public_eip.id
}



#__________________________________________________________
resource "aws_security_group" "security_groupe_public" {
  name        = "security_groupe_public_amar_henni"
  description = "Security group for public EC2 instances"
  vpc_id      = module.vpc_terraform.existing_vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "public_security_group"
  }
}
########################################################################### 

#Resource pour la generation de pair de cle
# resource "tls_private_key" "privatek" {
#     algorithm = "RSA"
#     rsa_bits = 4096
# }
# resource "aws_key_pair" "shittest" {
#     key_name = "shittest"
#     public_key = tls_private_key.privatek.public_key_openssh
# }
# resource "local_file" "keylocal" {
#     content = tls_private_key.privatek.private_key_pem
#     filename = "tfkey"
# }