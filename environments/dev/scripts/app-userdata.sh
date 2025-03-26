#!/bin/bash
sudo yum update -y
sudo yum install -y java-17-amazon-corretto
# 스프링 부트 JAR 넣을 경우:
# java -jar /home/ec2-user/myapp.jar &
