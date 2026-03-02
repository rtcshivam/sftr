variable "vpc_id" {
  description = "vpc id"
  type        = string

}



variable "name" {
  description = "name of the module"
  type        = string
}


variable "subnet_ids" {
  description = "subnet ids defined here"
  type        = list(string)
}

variable "gateway_id" {
  description = "defined the gatway its either igw and nat calling on the module"
  type        = string
}

variable "create_default_route" {
  description = "defaultes outes to the gaeways based on the 1 and 0, 1 is true and 0 is the false "
  type        = bool

}

variable "context" {
  type = object({
    project     = string
    environment = string
    tags        = map(string)
  })
}

variable "cidr_block" {
  description = "defined the cdr rnage of the gatway "
  type        = string

}