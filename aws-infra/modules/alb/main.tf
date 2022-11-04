#ALB
resource "aws_lb" "three-tier" {
  name               = "Three-Tier-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.jenkins_plus_ssh]
  subnets            = [var.public_subnets1_id, var.public_subnets2_id]

  tags = {
    Environment = "Three-Tier"
  }

}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.three-tier.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_alb_tg.arn
  }
}

#Target Group
resource "aws_lb_target_group" "jenkins_alb_tg" {
  name     = "jenkins-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

    health_check {
    path = "/"
    port = 8080
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"
  }

}

resource "aws_vpc" "main" {
  cidr_block = var.aws_main_vpc_cidr
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.jenkins_alb_tg.arn
  target_id        = var.ec2_id
  port             = 8080
}