region = "us-east-1"

vpc_cidr = "10.0.0.0/16"

public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24"
]

private_subnets = [
  "10.0.4.0/24",
  "10.0.5.0/24",
  "10.0.6.0/24"
]

azs = [
  "us-east-1a",
  "us-east-1b",
  "us-east-1c"
]

tags = {
  Environment = "prod"
  Project     = "rtctek"
}

environment = "prod"
project     = "rtctekdevops"


////////////route table module/////////////////
pvt-route-name = "privateRoute"
pb-route-name  = "pubRoute"
pvt_cidr       = "0.0.0.0/0"
public_cidr    = "0.0.0.0/0"
###########keymodule###############
key_name = "ec2keyr"

public_key_path = "C:/Users/shivam.sharma/.ssh/id_ed25519.pub" ########################



# //////////////bastioan hot mdoule/////////////////
bastian-module-name   = "bastian"
bastion-ami           = "ami-0b6c6ebed2801a5cb"
bastion_instance_type = "t2.micro"
allowed_ssh_cidr      = ["0.0.0.0/0"]


///////////////////ec2 in pvt subnet //////////
private_ec2-module-name = "pv-ec2"
private-ec2-ami         = "ami-0b6c6ebed2801a5cb"
pvtec2_instance_type    = "t2.micro"

max_size         = "4"
min_size         = "1"
desired_capacity = "1"