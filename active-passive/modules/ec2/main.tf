resource "aws_instance" "web" {
  count = length(var.subnet_ids)

  ami                    = "ami-0e001c9271cf7f3b9"
  instance_type          = "t2.micro"
  subnet_id              = element(var.subnet_ids, count.index)
  vpc_security_group_ids = var.security_groups

  tags = {
    Name = "Web Server ${count.index}"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Hello, World! subnet: ${count.index}</h1>" > /var/www/html/index.html
              systemctl restart nginx
              EOF
}

resource "aws_eip" "this" {
  count    = length(aws_instance.web)
  vpc      = true
  instance = aws_instance.web[count.index].id
}