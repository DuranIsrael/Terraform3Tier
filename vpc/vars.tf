# --- /vpc/vars.tf ---

variable "vpc_cidr" {}
variable "public_cidr" {}
variable "private_cidr" {}
variable "public_sn_count" {}
variable "private_sn_count" {}
variable "max_subnets" {}
variable "cidr_blocks" {}
variable "access_ip" {}
variable "ami_id" {}
variable "instance_type" {}
variable "aws_region" {}
variable "public_sg_name" {}
variable "key_name" {}