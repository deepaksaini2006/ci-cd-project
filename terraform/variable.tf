variable "region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "ami-0332d564d76dbd8d6"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "docker_image" {
  description = "deepaksaini98/jenkins-cicd-app:latest"
}