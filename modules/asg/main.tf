# resource "aws_security_group" "this" {
#   vpc_id = var.vpc_id

#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [var.bastion_sg_id]
#   }

#   # HTTP from ALB 
#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [var.alb_sg_id]
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

resource "aws_launch_template" "launch_template" {
  name_prefix            = "${var.context.environment}-${var.context.project}-${var.module_name}-lt-"
  image_id               = var.ami
  vpc_security_group_ids = var.security_group_ids
  instance_type          = var.instance_type
  key_name               = var.key_name


  # vpc_security_group_ids = [aws_security_group.this.id]


  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y 
    systemctl start nginx
    systemctl enable nginx
  EOF
  )



  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.context.tags,
      {
        Name = "${var.context.environment}-${var.context.project}-${var.module_name}"
      }
    )
  }
}

resource "aws_autoscaling_group" "scaling_grp" {
  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size

  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.context.environment}-${var.context.project}-${var.module_name}"
    propagate_at_launch = true
  }
}
