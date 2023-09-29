variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = "2"
  
}
variable "private_subnets" {
  default = "2"
}
variable "name" {
  default = "App1.0"
}

variable "environment" {
  default = "Terraform"
}

variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}