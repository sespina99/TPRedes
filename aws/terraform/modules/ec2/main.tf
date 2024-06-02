resource "aws_instance" "web" {
  count = length(var.subnet_ids)

  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = element(var.subnet_ids, count.index)
  vpc_security_group_ids = var.security_groups

  tags = {
    Name = "Web Server ${count.index}"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > /var/www/html/index.html
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF

}

resource "aws_eip" "eip" {
  count    = length(aws_instance.web)
  instance = aws_instance.web[count.index].id
  vpc      = true
}
