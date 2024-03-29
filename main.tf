# resource "aws_security_group" "public_sg_acces" {
#   name        = "public_sg_acces"
#   description = "Security group for public EC2 instances"
#   vpc_id      = data.aws_vpcs.existing_vpc.ids[0]
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "public_security_group"
#   }
# }




#Methode 1: Generation de key ssh sur linux
# provider "aws" {
#     region = "us-east-1"
# }
# resource "aws_instance" "ec2testssh" {
#     ami = "ami-0005e0cfe09cc9050"
#     instance_type = "t2.micro"
#     count = 1
#     key_name = "shittest"
#     tags = {
#       Name = "HelloWorldhhhh"
#     }
# }
# resource "aws_key_pair" "shittest" {
#     key_name = "shittest"
#     public_key = file("./id_rsa.pub")
# }
#--------------------------------------------
#Methode 2: Generation de key pair sur le console aws
# provider "aws" {
#     region = "us-east-1"
# }
# resource "aws_instance" "ec2testssh" {
#     ami = "ami-0005e0cfe09cc9050"
#     instance_type = "t2.micro"
#     count = 1
#     key_name = "shittest"
#     tags = {
#       Name = "HelloWorldhhhh"
#     }
# }
#-------------------------------------
#Methode3 : Utilisation de terraform resources

provider "aws" {
    region = "eu-west-1"
}

data "aws_vpcs" "existing_vpc" {                             # or aws_vpc 
  # Récupérer le VPC en fonction de l'ID
  # ids = ["vpc-005e78293bf3c2b77"]
  # OU récupérer le VPC en fonction du nom (par exemple, "mon-vpc")
  filter {
    name   = "tag:Name"
    values = ["km-devops-vpc-terraform"]
  }
}

output "existing_vpc_id" {
  value = data.aws_vpcs.existing_vpc.ids[0]
}

resource "aws_subnet" "main" {
  # vpc_id     = "vpc-005e78293bf3c2b77"
  vpc_id     = data.aws_vpcs.existing_vpc.ids[0]
  cidr_block = "50.10.190.0/24"
  tags = {
    Name = "subnet test nadjib 001"
  }
}

data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpcs.existing_vpc.ids[0]]
  }
}

output "internet_gateway_id" {
  value = data.aws_internet_gateway.default.id
}

resource "aws_instance" "ec2-test" {
    ami = "ami-0905a3c97561e0b69"
    instance_type = "t2.micro"
    count = 1
    subnet_id = aws_subnet.main.id
    #key_name = "shittest"
    tags = {
      Name = "Test-EC2-terraform-001"
      user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo apt-get install python3 -y
                EOF
    }
}

data "aws_eip" "by_public_eip" {
  public_ip = "54.77.91.63"
}

output "eip_id" {
  value = data.aws_eip.by_public_eip.id
}

#Table de routage pour la subnet
resource "aws_route_table" "public_route_table_nadjib_001" {
    vpc_id = data.aws_vpcs.existing_vpc.ids[0]
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = data.aws_internet_gateway.default.id
    }
    tags = {
        Name = "public_route_table_nadjib-test-001"
    }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.ec2-test[0].id
  allocation_id = data.aws_eip.by_public_eip.id
}

#Association de la table de routage pb au subnet public
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id      = aws_subnet.main.id
    route_table_id = aws_route_table.public_route_table_nadjib_001.id
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
