data "aws_vpc" "vpc_terraform" { # or aws_vpc 
  # Récupérer le VPC en fonction de l'ID
  # ids = ["vpc-005e78293bf3c2b77"]                          # ça ne marche pas
  # OU récupérer le VPC en fonction du nom (par exemple, "mon-vpc")
  filter {
    name   = "tag:Name"
    values = ["km-devops-vpc-terraform"]
  }
}

output "existing_vpc_id" {
  value = data.aws_vpc.vpc_terraform.id
}