resource "aws_alb" "alb" {
  name = "meu-app-load-balancer"
  subnets = var.public_subnets_ids
  security_groups = [var.sg-alb-id]
}

resource "aws_alb_target_group" "myapp-tg" {
  name        = "meuapp-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    matcher             = "200"
    path                = "/"
    interval            = 30
  
  }
  }

  resource "aws_alb_listener" "listener_app" {
  load_balancer_arn = aws_alb.alb.id
  port              = 80
  protocol          = "HTTP"
    default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.myapp-tg.arn
  }
}
  
output "target_group_arn" {
  value = aws_alb_target_group.myapp-tg.arn
}

output "alb_listener" {
  value = aws_alb_listener.listener_app
}