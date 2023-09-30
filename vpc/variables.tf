variable "name" {
  description = "Nome da Stack"
}
variable "environment" {
  description = "Nome do ambiente" 
}

variable "public_subnets" {
  description = "numero de subnets publicas"
}
variable "private_subnets" {
  description = "numerdo de subnets privadas"
}
variable "cidr_block" {
  description = "cidr block da VPC"
}