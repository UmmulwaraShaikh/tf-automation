variable "vpc_cidr" {
  type    = string
  description = "Enter the VPC CIDR Value."
}

variable "test_vpc" {
type = string
description = "Enter the Value for VPC"
}

//dynamic ingress and egress security group
variable "security_group_rules" {
    type = object({
    ingress = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    }))
    egress = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr_blocks = list(string)
    }))
    })

default = {
    ingress = [
      {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["100.123.1.0/32"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["100.123.2.0/32"]
    }
  ]
  egress = [
      {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
      }
     ]
    }
  }
variable "subnet_private_cidrs" {
 type = list(string)
 description = "Enter the value for subnet private cidrs"
}
variable "subnet_public_cidrs" {
 type = list(string)
 description = "Enter the value for subnet public cidrs"
}

//ec2_instance//

variable "instance_type" {
  type = string
  description = "Enter the value for instance type"
}
variable "instance_count" {
  type = number
  description = "Enter the value for instance count"
}
variable "instance_key_name" {
  type = string
  description = "Enter the value foe key name"
}
variable "vol_size" {
  type = number
  description = "Enter the value for volume size"
}

//s3 creation

variable "bucket_name" {
  type = string
  description = " Enter bucket name"
}

// IAM creation

variable "cloud_env" {
  type = string
  description = "Enter the Environment (dev/qa/prod)"
}


