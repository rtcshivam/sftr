variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

# variable "target_group_arn" {
#   type = string
# }

variable "context" {
  type = object({
    project     = string
    environment = string
    tags        = map(string)
  })
}

variable "module_name" {
  type = string
}






# target grp 
variable "port" {

}
variable "protocol" {

}

variable "health_check_path" {

}


variable "security_groups" {
  type = list(string)

}