module "vpc_terraform" {
  source = "../Vpc_module"
}

resource "aws_subnet" "terraform_subnet_amar_henni" {
  vpc_id     = module.vpc_terraform.existing_vpc_id
  cidr_block = var.cidr_block_value
  tags = {
    Name = var.subnet_name
  }
}

output "aws_subnet_module_id" {
  value = aws_subnet.terraform_subnet_amar_henni.id
}