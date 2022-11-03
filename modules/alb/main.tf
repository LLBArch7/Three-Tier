#ALB
resource "aws_lb" "three-tier" {
  name               = "Three-Tier-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins_plus_ssh.id]
  subnets            = [for subnet in aws_subnet.private_subnets1_id : subnet.id]

  tags = {
    Environment = "Three-Tier"
  }

  http_tcp_listeners = [
    # Forward action is default, either when defined or undefined
    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 0
      # action_type        = "forward"
    },

    {
      port        = 8080
      protocol    = "HTTP"
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed message"
        status_code  = "200"
      }
    },
  ]

}

#Target Group
resource "aws_lb_target_group" "jenkins_alb_tg" {
  name     = "jenkins-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_id
}

resource "aws_vpc" "main" {
  cidr_block = var.aws_main_vpc_cidr
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.jenkins_alb_tg.arn
  target_id        = var.ec2_id
  port             = 8080
}