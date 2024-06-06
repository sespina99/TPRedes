resource "aws_launch_template" "redes_launches" {
  name          = "redes-launches-template"
  image_id      = var.image_id
  instance_type = var.instance_type
  user_data     = filebase64("${path.module}/user_data.sh")

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = false
    subnet_id                   = var.subnet_public_a_id
    security_groups             = [var.security_group_id]
  }

  network_interfaces {
    device_index                = 1
    associate_public_ip_address = false
    subnet_id                   = var.subnet_public_b_id
    security_groups             = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "redes-instance"
    }
  }
}

resource "aws_autoscaling_group" "redes_asg" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  target_group_arns   = [var.lb_target_group_arn]
  vpc_zone_identifier = [var.subnet_private_a_id, var.subnet_private_b_id]

  launch_template {
    id      = aws_launch_template.redes_launches.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "redes-instance-${uuid()}"
    propagate_at_launch = true
  }
}
