resource "aws_subnet" "subnets" {
  count             = length(var.cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidrs[count.index]
  availability_zone = var.azs[count.index]
  tags = merge(
    var.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-${var.module_name}-${var.azs[count.index]}"
    }
  )
}

