resource "aws_lb" "redes_lb" {
  name               = "redes-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.subnet_public_a_id, var.subnet_public_b_id]
  depends_on         = [var.internet_gateway_id]
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.redes_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
