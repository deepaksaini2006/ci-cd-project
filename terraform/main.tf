provider "aws" {
  region = var.region
}

resource "aws_security_group" "app_sg" {
  name        = "jenkins-cicd-app-sg"
  description = "Security group for CI/CD application"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "app_server" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = ["sg-012dd3c6097a1972b"]
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = templatefile("${path.module}/userdata.sh", {
    docker_image = var.docker_image
  })

  tags = {
    Name = "jenkins-terraform-cicd-server"
  }
}
