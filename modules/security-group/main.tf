resource "aws_security_group" "security_grp" {
  name        = "${var.context.environment}-${var.context.project}-${var.name}"
  description = var.description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_cidr_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = lookup(ingress.value, "description", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-${var.name}"
    }
  )
}


resource "aws_security_group_rule" "ingress_from_sg" {
  for_each = {
    for idx, rule in var.ingress_sg_rules :
    idx => rule
  }

  type      = "ingress"
  from_port = each.value.from_port
  to_port   = each.value.to_port
  protocol  = each.value.protocol

  security_group_id        = aws_security_group.security_grp.id
  source_security_group_id = each.value.source_security_group_id
  description              = lookup(each.value, "description", null)
}
