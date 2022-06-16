# --- loadbalancing/main.tf ---


resource "aws_lb" "wk22_lb" {
  name = "wk22-lb"
  load_balancer_type = "application"
  subnets = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout = 400
}
resource "aws_lb_target_group" "wk22_lbtg" {
  name        = "wk22-tg"
  target_type = "alb"
  port        = var.tg_port #80
  protocol    = var.tg_protocol #HTTP
  vpc_id      = var.vpc_id
  health_check {
    healthy_threshold = var.lb_healthy_threshold #2
    unhealthy_threshold = var.lb_unhealthy_threshold #2
    timeout = var.lb_timeout #3
    interval = var.lb_interval #30
  }
}

resource "aws_lb_listener" "wk22_lb_listner" {
  load_balancer_arn = aws_lb.wk22_lb.arn
  port = var.listener_port #80
  protocol = var.listener_protocol # HTTP
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.wk22_lbtg.arn
  }

}