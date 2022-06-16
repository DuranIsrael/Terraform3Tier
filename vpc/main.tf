# --- /vpc/main.tf ---

data "aws_availability_zones" "available" {}

data "aws_region" "current" {}

resource "random_integer" "random" {
  min = 1
  max = 1000
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "aws_vpc" "wk22_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "wk22_vpc"
  }
}



resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.wk22_vpc.id
  cidr_block = var.public_cidr
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names

  tags = {
    Name = "bastion_public"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.wk22_vpc.id
  cidr_block = var.private_cidr
  availability_zone = data.aws_availability_zones.available.names

  tags = {
    Name = "private_subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "wk22_igw"
  }
}

resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "public security group"
  vpc_id      = aws_vpc.wk22_vpc.id



  #public Security Group
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
    
  }

  ingress {
      description = "for remote access"
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [var.cidr_blocks]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_blocks]
  }
}