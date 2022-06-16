 #--- Modules/ASG/resource.tf ---

data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["137112412989"]

    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220426.0-x86_64-*"]
    }

}

resource "aws_launch_configuration" "example_launchconfig" {
name_prefix = "example-launchconfig"
image_id = "${lookup(var.ami_id, var.aws_region)}"
instance_type = var.instance_type
key_name = var.key_name
security_groups = aws_security_group.public_sg.id
}

resource "aws_autoscaling_policy" "example_asp" {
  name                   = "bastion-as-policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.example_web.name
}

resource "aws_launch_template" "example_lt" {
  name_prefix   = "bastion-asg"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_group_names = var.public_sg_name
}

resource "aws_autoscaling_group" "example_web" {
  name                = "bastion-autoscaling"
  vpc_zone_identifier = aws_subnet.public_subnet.id
  min_size            = 1
  max_size            = 5
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.example_lt.id
    version = "$Latest"
  }
}