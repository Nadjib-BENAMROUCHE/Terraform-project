variable "ec2_ami" {
  type = string
}

variable "ec2_instance_type" {
  type = string
}

variable "ec2_subnet_id" {
  type = string
}

variable "ec2_subnet_name" {
  type = string
}

variable "ec2_sg_ids" {
  type = set(string)
}
