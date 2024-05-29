
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  load_balancer_type = "application"
  internal = false
  security_groups = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "this" {
  name     = "tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_a" {
 count = length(var.instance_ids)
 target_group_arn = aws_lb_target_group.this.arn
 target_id        = element(var.instance_ids, count.index)
 port             = 80
}