variable "region" {
  description = "region defined"
  type        = string
}
variable "vpc_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "azs" {}
variable "tags" {}
variable "environment" {

}
variable "project" {

}
# /////////public route table module vars ////////////////////


variable "pb-route-name" {
  description = "name of the module"
  type        = string

}

variable "public_cidr" {
  description = "cidr rang for the public "
  type        = string
}


# ////////////////////pvt route table module vars ????????????
variable "pvt-route-name" {
  description = "name of the the module"
  type        = string

}

variable "pvt_cidr" {
  description = "cidr range of the pvt block"
  type        = string

}




####key module#####
variable "key_name" {

  description = "key name of the ssh"
  type        = string
}

variable "public_key_path" {

  description = "path of the the file to login in the server"
  type        = string
}


# ////////bastion host//////

variable "bastian-module-name" {

  description = "module name defined"
  type        = string

}

variable "bastion-ami" {
  description = "ami of the astion instance defined"
  type        = string

}


variable "bastion_instance_type" {
  description = "isntance type "
  type        = string

}

variable "allowed_ssh_cidr" {
  description = "ssh allowed cidr to the server "
  type        = list(string)
}

# ////////////private ec2 /////////////
# private_ec2-module-name

variable "private_ec2-module-name" {
  description = "mdoule name of pvt ec2 defined "
  type        = string
}


variable "private-ec2-ami" {
  description = "ami idof the pvt ec2  defined"
  type        = string
}

variable "pvtec2_instance_type" {
  description = "instace type of the pvt ec2 "
  type        = string

}


# ///////////////asggrp//
variable "min_size" {
  description = "minimum number of ec2s"
  type        = string

}

variable "max_size" {
  description = "maximum number of  ec2s"
  type        = string

}

variable "desired_capacity" {

  description = "stable ec2s number"
  type        = string
}

