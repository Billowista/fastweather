module "fastweather_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "fastweather"
  description = "Fastweather security group. Port 80 open publicly, 5000 internally"
  vpc_id      = "${aws_vpc.fastweather.id}"

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = [""]
  ingress_with_cidr_blocks = [
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      description = "Internal port to container"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Open to public"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}
resource "aws_lb_target_group" "fastweather_elb_target_group" {
  name     = "fastweather-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.fastweather.id}"
}

resource "aws_vpc" "fastweather" {
  cidr_block = "10.0.0.0/16"
}
module "fastweather_elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "fastweather-elb"

  subnets         = []
  security_groups = ["${fastweather_security_group_id}"]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = [
    {
      target              = "HTTP:80/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

  access_logs = [
    {
      bucket = "fastweather-access-logs"
    },
  ]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

