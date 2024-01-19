
module "vpc_terraform" {
  source = "../Vpc_module"
}

resource "aws_instance" "ec2-amar" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type

  vpc_security_group_ids = var.ec2_sg_ids #[aws_security_group.security_groupe_public.id]
  subnet_id              = var.ec2_subnet_id

  tags = {
    Name      = var.ec2_subnet_name
  }
}



output "ec2_id" {
    value =  aws_instance.ec2-amar.id
}