resource "aws_security_group" "main" {
  name = var.name
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name: "${var.name}-sec-group-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_security_group" "alb_sg" {
  name = "alb-sec-group-app"
  description = "Sec-group-app"
  vpc_id = var.vpc_id

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "sg_id" {
  value = aws_security_group.main.id
}

output "sg-id-alb" {
  value = aws_security_group.alb_sg.id
}