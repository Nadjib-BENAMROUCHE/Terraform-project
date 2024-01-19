variable "sg_name" {
  type = string
}
variable "from_port" {
  type = number
}
variable "to_port" {
  type = number
}
variable "protocol" {
  type = string
}
variable "cidr_blocks" {
  type = set(string)
}
variable "from_port_in" {
  type = number
}
variable "to_port_in" {
  type = number
}
variable "protocol_in" {
  type = string
}
variable "cidr_blocks_in" {
  type = set(string)
}
variable "vpc_id" {
  type = string
}

