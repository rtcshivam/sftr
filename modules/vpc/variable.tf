variable "cidr" {
  description = "cidr range of vpc"
  type        = string
}
variable "tags" {
  description = ""
  type        = map(string)
}
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