provider aws {
    region = var.region
}



data "aws_vpc" "example" {
  tags = {
    Name = "Default"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.example.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidrssh
  from_port         = var.ssh
  ip_protocol       = "tcp"
  to_port           = var.ssh

}

resource "aws_vpc_security_group_ingress_rule" "allow_ephemeral_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidrephemeral
  from_port         = var.inbound
  ip_protocol       = "tcp"
  to_port           = var.inbound

}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_instance" "jenkinsserver" {
  
  ami = "ami-062f0cc54dbfd8ef1"
  instance_type = "t3.large"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data = <<-EOF
        #!/bin/bash
        yum update -y
        wget -O /etc/yum.repos.d/jenkins.repo \
            https://pkg.jenkins.io/redhat-stable/jenkins.repo
        rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
        yum upgrade -y
        yum install java-17-amazon-corretto -y
        yum install jenkins -y
        systemctl enable jenkins
        systemctl start jenkins
        
    EOF
tags = {
    Name = var.ec2instance

}

}