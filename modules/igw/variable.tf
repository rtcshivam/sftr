variable "vpc_id" {}
variable "tags" {}
variable "context" {
  type = object({
    project     = string
    environment = string
    tags        = map(string)
  })
}

variable "module_name" {
  description = "name of the module"
}