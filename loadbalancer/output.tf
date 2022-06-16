# --- loadbalancer/outputs.tf ---

output "lb_target_group_arn" {
  value = aws_lb_target_group.wk22_lbtg.arn
}

output "lb_endpoint" {
  value = aws_lb.wk22_lb.dns_name
}