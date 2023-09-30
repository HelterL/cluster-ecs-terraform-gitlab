terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.4.2"
}

provider "aws" {
  region  = "us-east-1"
}

terraform {
    backend "s3" {
    bucket = "projetodevopstf"
    key = "terraformecs.tfstate"
    region = "us-east-1"
    encrypt = true
    }
}

module "vpc" {
  source = "./vpc"
  cidr_block = var.cidr_block
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  name = var.name
  environment = var.environment
}

module "iam" {
  source = "./iam"
  ecs_task_execution_role = var.ecs_task_execution_role
}

module "sec_group" {
  source = "./sec_group"
  name = var.name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
}

module "ecs" {
  source = "./ecs"
  name = var.name
  environment = var.environment
  sec_group_id = module.sec_group.sg_id
  public_subnets_ids = module.vpc.public_subnets_ids
  iam_role_policy_attachment = module.iam.iam_role
  iam_role_arn = module.iam.aws_iam_role_arn
  alb_listener = module.alb.alb_listener
  alb_target_group_arn = module.alb.target_group_arn
}

module "alb" {
  source = "./alb"
  public_subnets_ids = module.vpc.public_subnets_ids
  sg-alb-id = module.sec_group.sg-id-alb
  vpc_id = module.vpc.vpc_id
}

module "asg" {
  source = "./asg"
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_cluster_service = module.ecs.ecs_cluster_service
}
