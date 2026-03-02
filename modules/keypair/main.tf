resource "aws_key_pair" "keypair" {
  key_name   = "${var.context.environment}-${var.context.project}-${var.key_name}"
  public_key = var.public_key_path

  tags = merge(
    var.context.tags,
    {
      Name = "${var.context.environment}-${var.context.project}-keypair"
    }
  )
}
