# --- root/main.tf ---


module "vpc" {
  source           = "./vpc"
  vpc_cidr         = "10.0.0.0/16"
  public_sn_count  = 2
  private_sn_count = 2
  max_subnets      = 5
  public_cidr      = ["10.0.2.0/24", "10.0.4.0/24"]
  private_cidr     = ["10.0.3.0/24", "10.0.5.0/24"]
  cidr_blocks      = "0.0.0.0/0"
  access_ip        = ["0.0.0.0/0"]
  instance_type    = "t2.micro"
  public_sg_name   = module.vpc.public_sg.name
  key_name         = "MyNewKeyPair"
  ami_id           = var.ami_id
  aws_region       = var.aws_region

}


module "EC2" {
  source              = "./EC2"
  instance_count      = 2
  instance_type       = "t2.micro"
  public_sg           = module.vpc.public_sg
  public_subnets      = module.vpc.public_subnets
  vol_size            = 10
  key_name            = "MyNewKeyPair"
  public_key_path     = "/Users/jehuisrael/Documents/KeyPairs"
  lb_target_group_arn = module.loadbalancer.lb_target_group_arn
  ami_id              = var.ami_id

}

module "loadbalancer" {
  source                 = "./loadbalancer"
  public_sg              = module.vpc.public_sg
  public_subnets         = module.vpc.public_subnets
  tg_port                = 80
  tg_protocol            = "HTTP"
  vpc_id                 = module.vpc.vpc_id
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
}