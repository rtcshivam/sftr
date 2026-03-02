resource "aws_route_table" "routetable" {
  vpc_id = var.vpc_id

  dynamic "route" {
    for_each = var.create_default_route ? [1] : []
    content {
      cidr_block = var.cidr_block
      gateway_id = var.gateway_id
    }
  }

  tags = merge(
    var.context.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-${var.name}"
    }
  )
}

resource "aws_route_table_association" "rt_association" {
  count          = length(var.subnet_ids)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.routetable.id
}
