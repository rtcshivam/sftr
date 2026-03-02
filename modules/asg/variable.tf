variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

# variable "bastion_sg_id" {
#   type = string
# }

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

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

# variable "alb_sg_id" {
#     description = "alb secruty id "
#     type =string

# }


variable "target_group_arn" {
  description = "traget group arn "
  type        = string
}

variable "security_group_ids" {
  description = "sg"
  type        = list(string)
}