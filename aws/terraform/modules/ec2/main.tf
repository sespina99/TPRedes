resource "aws_instance" "web" {
  count = length(var.subnet_ids)

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index)

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

resource "aws_security_group" "web" {
  name        = "web_security_group"
  description = "Allow HTTP traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
