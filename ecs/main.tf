resource "aws_ecs_cluster" "cluster" {
  name = "Cluster"
  setting {
    name = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name = "${var.name}-ecs-cluster-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}


resource "aws_ecs_task_definition" "task" {
  family = "service"
  task_role_arn = aws_iam_role.ecs_task_role.arn
  execution_role_arn = var.iam_role_arn
  network_mode = "awsvpc"
  requires_compatibilities = [ "FARGATE", "EC2" ]
  cpu = 512
  memory = 1024
  container_definitions = jsonencode([
    {
      name      = "app_lab"
      image     = "${var.repo_url_ecr}:6"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name = "service"
  enable_execute_command = true
  cluster = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.id
  desired_count = 1
  launch_type = "FARGATE"
  platform_version = "LATEST"

  network_configuration {
    assign_public_ip = true
    security_groups = [var.sec_group_id]
    subnets = var.public_subnets_ids
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_port = 80
    container_name = "app_lab"
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
  depends_on = [var.alb_listener,var.iam_role_policy_attachment, var.repo_url_ecr]
}

output "ecs_cluster_name" {
 value = aws_ecs_cluster.cluster.name 
}

output "ecs_cluster_service" {
  value = aws_ecs_service.service.name
}