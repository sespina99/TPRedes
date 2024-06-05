resource "aws_lb" "redes_albalancer" {
  name               = "redes-albalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.subnet_public_a_id, var.subnet_public_b_id]
  depends_on         = [var.internet_gateway_id]
}

resource "aws_lb_target_group" "alb_target_groups" {
  name     = "tf-lb-alb-target-groups"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.redes_albalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_groups.arn
  }
}
