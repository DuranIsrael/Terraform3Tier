# --- /EC2/vars.tf ---

variable "instance_count" {}
variable "ami_id" {}
variable "instance_type" {}
variable "public_sg" {}
variable "public_subnets" {}
variable "vol_size" {}
variable "key_name" {}
variable "public_key_path" {}
variable "lb_target_group_arn" {}