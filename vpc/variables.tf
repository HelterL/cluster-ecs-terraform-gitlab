variable "name" {
  description = "Nome da Stack"
}
variable "environment" {
  description = "Nome do ambiente" 
}

variable "public_subnets" {
  description = "subnets publicas"
}
variable "private_subnets" {
  description = "subnets privadas"
}
variable "cidr_block" {
  description = "cidr block da VPC"
}