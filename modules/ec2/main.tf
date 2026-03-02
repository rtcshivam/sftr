# resource "aws_security_group" "this" {
#   vpc_id = var.vpc_id

#   dynamic "ingress" {
#     for_each = var.ingress_rules
#     content {
#       from_port       = ingress.value.from_port
#       to_port         = ingress.value.to_port
#       protocol        = ingress.value.protocol
#       cidr_blocks     = lookup(ingress.value, "cidr_blocks", null)
#       security_groups = lookup(ingress.value, "security_groups", null)
#     }
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

# resource "aws_instance" "this" {
#   ami                         = var.ami
#   instance_type               = var.instance_type
#   subnet_id                   = var.subnet_id
#   vpc_security_group_ids       = [aws_security_group.this.id]
#   key_name                    = var.key_name
#   associate_public_ip_address = var.associate_public_ip

#   tags = merge(
#     var.context.tags,
#     {
#       Name = "${var.context.environment}-${var.context.project}-${var.module_name}"
#     }
#   )
# }




# resource "aws_security_group" "this" {

#   vpc_id = var.vpc_id

#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = var.allowed_ssh_cidr
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#     tags = merge(
#     var.context.tags,
#     {
#       Name = "${var.context.environment}-${var.context.project}-sg"
#     }
#   )
# }

resource "aws_instance" "ec2_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = var.security_grp
  associate_public_ip_address = var.associate_public_ip

  tags = merge(
    var.context.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-${var.module_name}"
    }
  )
}


