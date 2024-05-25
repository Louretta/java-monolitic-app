# Bastion security group
resource "aws_security_group" "bastion_sg" {
    name        = "bastion-sg"
    description = "Bastion security group"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH access"
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

    tags = {
        Name = "bastion-sg"
    }
}

# SonarQube security group
resource "aws_security_group" "sonarqube_sg" {
    name        = "sonarqube-sg"
    description = "SonarQube security group"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SonarQube port"
        from_port   = 9000
        to_port     = 9000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS port"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "sonarqube-sg"
    }
}

# Jenkins security group
resource "aws_security_group" "jenkins_sg" {
    name        = "jenkins-sg"
    description = "Jenkins security group"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Jenkins port"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS port"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "jenkins-sg"
    }
}

# Ansible security group
resource "aws_security_group" "ansible_sg" {
    name        = "ansible-sg"
    description = "Ansible security group"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH access"
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

    tags = {
        Name = "ansible-sg"
    }
}

# Nexus security group
resource "aws_security_group" "nexus_sg" {
    name        = "nexus-sg"
    description = "Nexus security group"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Nexus port"
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Additional Nexus port"
        from_port   = 8085
        to_port     = 8085
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS port"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "nexus-sg"
    }
}

# ASG security group
resource "aws_security_group" "asg-sg" {
    name        = "asg-sg"
    description = "ASG security group"
    vpc_id      = var.vpc_id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Port 8080"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS port"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "asg-sg"
    }
}

#create RDS security group
resource "aws_security_group" "rds-sg" {
    name        = "rds-sg"
    description = "RDS security group"
    vpc_id      = var.vpc_id

    ingress {
        description     = "MySQL access"
        from_port       = 3306
        to_port         = 3306
        protocol        = "tcp"
        security_groups = [aws_security_group.bastion_sg.id, aws_security_group.asg-sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds-sg"
    }
}
