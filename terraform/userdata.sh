#!/bin/bash

yum update -y

yum install docker -y

systemctl start docker
systemctl enable docker

sleep 15

docker pull ${docker_image}

docker run -d \
  --name cicd-app \
  --restart always \
  -p 80:80 \
  ${docker_image}