# --- /EC2/outputs.tf ---

output "aws_instance" {
  value = aws_instance.wk22_bastion[*].public_ip
}

output "ec2_tags" {
  value = aws_instance.wk22_bastion[*].tags_all.Name
}