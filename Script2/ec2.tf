resource "aws_launch_template" "redes_launch" {
  name          = "redes-launch-template"
  image_id      = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  user_data     = filebase64("user_data.sh")

  # Primer interfaz de red en la primera subnet
  network_interfaces {
    device_index                 = 0
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.public_a.id
    security_groups             = [aws_security_group.sg_for_ec2.id]
  }

  # Segundo interfaz de red en la segunda subnet
  network_interfaces {
    device_index                 = 1
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.public_b.id
    security_groups             = [aws_security_group.sg_for_ec2.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "redes-instance"
    }
  }
}

resource "aws_autoscaling_group" "redes_asg" { 
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1

  target_group_arns    = [aws_lb_target_group.alb_tg.arn]
  vpc_zone_identifier  = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  launch_template {
    id      = aws_launch_template.redes_launch.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "redes-instance-${uuid()}" 
    propagate_at_launch = true
  }
}
