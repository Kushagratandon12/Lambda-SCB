#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker run -d --restart always -p 80:8080 gcr.io/google-samples/hello-app:1.0