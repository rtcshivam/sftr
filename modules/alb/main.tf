# # ALB Security Group
# resource "aws_security_group" "this" {
#   vpc_id = var.vpc_id

#   ingress {
#     description = "HTTP from Internet"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = merge(
#     var.context.tags,
#     {
#       Name = "${var.context.environment}-${var.context.project}-${var.module_name}-sg"
#     }
#   )
# }

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.context.environment}-${var.context.project}-${var.module_name}"
  internal           = false
  load_balancer_type = "application"
  # security_groups    = [aws_security_group.this.id]
  security_groups = var.security_groups
  subnets         = var.public_subnet_ids

  tags = merge(
    var.context.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-${var.module_name}"
    }
  )
}


resource "aws_lb_target_group" "tg" {
  name        = "${var.context.project}-${var.context.environment}-${var.module_name}-tg"
  port        = var.port
  protocol    = var.protocol
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled = true
    path    = var.health_check_path
    matcher = "200"
  }

  tags = merge(
    var.context.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-${var.module_name}-tg"
    }
  )
}


# Listener (HTTP → Target Group)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}


