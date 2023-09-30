variable "name" {
  description = "Nome da Stack"
}

variable "environment" {
  description = "Nome do ambiente"
}

variable "sec_group_id" {
  description = "ID do security Group"
}

variable "public_subnets_ids" {
  description = "IDs das subnets publicas"
}

variable "alb_target_group_arn" {
  description = "arn do target group"
}

variable "alb_listener" {
  description = "listener do alb"
}

variable "iam_role_policy_attachment" {
  description = "iam role"
}

variable "iam_role_arn" {
  description = "iam role arn"
}

variable "repo_url_ecr" {
  description = "URL do repo de imagens"
}