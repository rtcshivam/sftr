resource "aws_eip" "nat_eip" {
  tags = var.tags
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_id
  tags = merge(
    var.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-${var.module_name}"
    }
  )
}
