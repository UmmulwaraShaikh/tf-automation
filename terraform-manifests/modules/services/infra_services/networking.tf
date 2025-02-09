resource "aws_vpc" "terraform_test_vpc" {
  cidr_block         = var.vpc_cidr
  enable_dns_hostnames = false
  enable_dns_support   = true

lifecycle { 
    create_before_destroy = true 
  } 


  tags = {
    Name = var.test_vpc
  }
}
resource "aws_internet_gateway" "terraform_test_internet_gateway" {
  vpc_id = aws_vpc.terraform_test_vpc.id
  tags = {
    Name = "${var.cloud_env}_terraform_test_igw"
  }
}
resource "aws_route_table" "terraform_private_rt" {
  vpc_id = aws_vpc.terraform_test_vpc.id
  tags = {
    Name = "${var.cloud_env}_terraform_private_route_table"
  }
}
resource "aws_route_table" "terraform_public_rt" {
  vpc_id = aws_vpc.terraform_test_vpc.id
  tags = {
    Name = "${var.cloud_env}_terraform_public_route_table"
  }
}
resource "aws_route" "public_route" {
   route_table_id = aws_route_table.terraform_public_rt.id
   destination_cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.terraform_test_internet_gateway.id
 }
resource "aws_security_group" "terraform_test_sg" {
  name = "terraform_test_sg"
  description = "Security group for public instances"

  vpc_id = aws_vpc.terraform_test_vpc.id
dynamic "ingress" {
    for_each = var.security_group_rules.ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
dynamic "egress" {
    for_each = var.security_group_rules.egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}
data "aws_availability_zones" "available" {}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.terraform_test_vpc.id
  cidr_block = var.subnet_private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.cloud_env}_private_subnet"
  }
}
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.terraform_test_vpc.id
  cidr_block = var.subnet_public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "${var.cloud_env}_public_subnet"
  }
}

resource "aws_route_table_association" "public_association" {
  count = 2
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.terraform_public_rt.id
}

resource "aws_route_table_association" "private_association" {
  count = 2
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.terraform_private_rt.id
}





