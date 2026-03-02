variable "vpc_id" {}
variable "cidrs" {}
variable "azs" {}
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


variable "map_public_ip_on_launch" {
  description = "descibe the ip addres "
  type        = bool

}