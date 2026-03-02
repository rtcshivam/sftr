variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "associate_public_ip" {
  description = "ture or false for public ipallocaition "
  type        = bool
}


variable "module_name" {
  type = string
}

variable "context" {
  type = object({
    project     = string
    environment = string
    tags        = map(string)
  })
}

# variable "allowed_ssh_cidr"{
#     description = "cidr range for ingrees in server"
#     type = list(string)
# }


variable "security_grp" {
  type = list(string)

}

variable "create_ami" {
  description = "Whether to create AMI from this EC2"
  type        = bool
  default     = false
}
