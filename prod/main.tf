provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "../modules/vpc"
  cidr        = var.vpc_cidr
  tags        = var.tags
  module_name = "vpc"
  context     = local.context
}

module "igw" {
  source      = "../modules/igw"
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
  module_name = "igw"

  context = local.context
}


module "public_subnets" {
  source                  = "../modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidrs                   = var.public_subnets
  azs                     = var.azs
  map_public_ip_on_launch = true

  tags        = var.tags
  context     = local.context
  module_name = "public-subnet"
}

module "private_subnets" {
  source                  = "../modules/subnet"
  vpc_id                  = module.vpc.vpc_id
  cidrs                   = var.private_subnets
  azs                     = var.azs
  tags                    = var.tags
  map_public_ip_on_launch = false
  module_name             = "private-subnet"

  context = local.context
}

module "nat" {
  source           = "../modules/nat"
  public_subnet_id = module.public_subnets.subnet_ids[0]
  tags             = var.tags
  module_name      = "natgatway"
  context          = local.context
}

# module "public_routes" {
#   source     = "../modules/route-public"
#   vpc_id     = module.vpc.vpc_id
#   igw_id     = module.igw.igw_id
#   subnet_ids = module.public_subnets.subnet_ids
#    tags   = var.tags

#   module_name = "public-routes table"
#  context = local.context
# }

# module "private_routes" {
#   source     = "../modules/route-private"
#   vpc_id     = module.vpc.vpc_id
#   nat_id     = module.nat.nat_id
#   subnet_ids = module.private_subnets.subnet_ids
#   tags       = var.tags
#   module_name = "public-routes table"
#  context = local.context
# }

module "public-route-table" {
  source               = "../modules/route-table"
  vpc_id               = module.vpc.vpc_id
  cidr_block           = var.public_cidr
  subnet_ids           = module.public_subnets.subnet_ids
  gateway_id           = module.igw.igw_id
  create_default_route = true
  name                 = var.pb-route-name

  context = local.context
}

module "pvt-route-table" {
  source               = "../modules/route-table"
  vpc_id               = module.vpc.vpc_id
  cidr_block           = var.pvt_cidr
  subnet_ids           = module.private_subnets.subnet_ids
  gateway_id           = module.nat.nat_id
  create_default_route = true
  name                 = var.pvt-route-name
  context              = local.context
}




module "keypair" {
  source          = "../modules/keypair"
  key_name        = var.key_name
  public_key_path = file(var.public_key_path)
  context         = local.context
}


# ////ec2 module////////
# module "bastion_ec2" {
#   source      = "../modules/ec2"
#   module_name = "bastion"
#   context     = local.context

#   vpc_id      = module.vpc.vpc_id
#   subnet_id   = module.public_subnets.subnet_ids[0]

#   ami                 = var.ami
#   instance_type       = var.bastion_instance_type
#   key_name            = module.keypair.key_name
#   associate_public_ip = true

#   ingress_rules = [
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "ssh"
#       cidr_blocks = var.allowed_ssh_cidr
#     }
#   ]
# }


module "bastian_ec2_sg" {
  source = "../modules/security-group"

  vpc_id      = module.vpc.vpc_id
  name        = "bastion-ec2-sg"
  description = "Allow traffic only from ALB"

  ingress_cidr_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags    = var.tags
  context = local.context
}


module "bastion" {
  source = "../modules/ec2"

  module_name = var.bastian-module-name
  context     = local.context

  vpc_id = module.vpc.vpc_id
  # subnet_id   = module.public_subnet_ids[0]
  subnet_id = module.public_subnets.subnet_ids[0]

  # subnet_id = module.public_subnets_id[0]
  ami_id              = var.bastion-ami
  instance_type       = var.bastion_instance_type
  key_name            = module.keypair.key_name
  associate_public_ip = true
  security_grp        = [module.bastian_ec2_sg.security_group_id]
  # allowed_ssh_cidr = var.allowed_ssh_cidr
  


}



# module "private_ec2" {
#   source = "../modules/ec2"

#   project              = var.project
#   env                  = var.env
#   ami_id               = var.ami_id
#   instance_type        = public_subnetsvar.instance_type_private
#   subnet_id            = module.vpc.private_subnet_ids[0]
#   vpc_id               = module.vpc.vpc_id
#   associate_public_ip  = false

#   key_name        = var.key_name
#   public_key_path = var.public_key_path

#   # SSH ONLY FROM BASTION
#   allowed_ssh_cidr = ["${module.bastion.private_ip}/32"]

#   tags = {
#     Role = "private"
#   }
# }

# module_name =  var.private_ec2-module-name
# context     = local.context

#   vpc_id      = module.vpc.vpc_id
#   subnet_id = module.private_subnets.subnet_ids[0]

#   ami_id              = var.private-ec2-ami
#   instance_type       = var.pvtec2_instance_type
#   key_name            = module.keypair.key_name
#   associate_public_ip = false

#   # SSH ONLY FROM BASTION
#   allowed_ssh_cidr = ["${module.bastion.private_ip}/32"]
# }

# //////////////////////////////////////asg group for the pvt ec2& alb/////////////////////////

module "asg_sg" {
  source = "../modules/security-group"


  vpc_id      = module.vpc.vpc_id
  name        = "asg"
  description = "HTTP from Internet"

  ingress_cidr_rules = [
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      # cidr_blocks = [format("%s/32", module.bastion.private_ip)]
      cidr_blocks = ["${module.bastion.private_ip}/32"]
    }


  ]
  ingress_sg_rules = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
      description              = "HTTP from ALB only"
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]

    }
  ]

  tags    = var.tags
  context = local.context
}


module "private_asg" {
  source      = "../modules/asg"
  module_name = "private-asg"
  context     = local.context

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.private_subnets.subnet_ids

  ami              = var.private-ec2-ami
  instance_type    = var.pvtec2_instance_type
  key_name         = module.keypair.key_name
  target_group_arn = module.alb.target_group_arn
  # bastion_sg_id = module.bastian_ec2_sg.security_group_id
  # alb_sg_id = module.alb-sg.security_group_id
  security_group_ids = [module.asg_sg.security_group_id]
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
}



module "alb_sg" {
  source = "../modules/security-group"

  vpc_id      = module.vpc.vpc_id
  name        = "alb_sg"
  description = "HTTP from Internet"

  ingress_cidr_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  tags    = var.tags
  context = local.context
}

# module "alb_sg" {
#   source = "../modules/security-group"


#  vpc_id      = module.vpc.vpc_id
#   name        = "alb_sg"
#   description = "HTTP from Internet"

#   ingress_cidr_rules = [
#     {
#       from_port   = 80
#       to_port     = 80
#       protocol    = "tcp"
#       cidr_blocks =  ["0.0.0.0/0"]
#     }
#   ]

#   egress_rules = [
#     {
#       from_port   = 0
#       to_port     = 0
#       protocol    = "-1"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   ]

#   tags    = var.tags
#   context = local.context
# }



# module "app_target_group" {
#   source      = "../modules/target-group"
#   module_name = "targetgrp"
#   context     = local.context

#   vpc_id = module.vpc.vpc_id
#   port   = 80

#   health_check_path = "/"
# }

module "alb" {
  source            = "../modules/alb"
  module_name       = "alb"
  context           = local.context
  port              = "80"
  protocol          = "HTTP"
  security_groups   = [module.alb_sg.security_group_id]
  health_check_path = "/"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.public_subnets.subnet_ids

  # target_group_arn = module.app_target_group.target_group_arn
}



