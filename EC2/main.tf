# --- /ec2/instances ---

data "aws_ami" "server_ami" {
    most_recent = true
    owners = ["137112412989"]

    filter {
        name = "name"
        values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220426.0-x86_64-*"]
    }

}

resource "aws_key_pair" "wk22_kp" {
    key_name = var.key_name
    public_key = file(var.public_key_path)

}
resource "aws_instance" "wk22_private" {
     #2
    instance_type = var.instance_type #t2.micro
    ami = data.aws_ami.server_ami.id
    tags = {
        Name = "wk22_private"
    }
}

resource "aws_instance" "wk22_bastion" { #2
    instance_type = var.instance_type #t2.micro
    ami = data.aws_ami.server_ami.id
    tags = {
        Name = "wk22_bastion"
    }

key_name = aws_key_pair.wk22_kp.id
vpc_security_group_ids = [var.public_sg]
subnet_id = var.public_subnets



root_block_device {
    volume_size = var.vol_size #10
    }
}
resource "aws_lb_target_group_attachment" "wk22_tga" {
    count = var.instance_count
    target_group_arn = var.lb_target_group_arn
    target_id = aws_instance.wk22_bastion.id
    port = 8000
}