locals {
  context = {
    project     = var.project
    environment = var.environment
    tags = merge(
      var.tags,
      {
        Project     = var.project
        Environment = var.environment
      }
    )
  }
}
