#Bastion security group 
resource "aws_security_group" "bastion_sg" {
    name = "bastion-sg"
    description = "bastion security group"
    vpc_id = var.vpc_id 


ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {
    from_port= 0
    to_port =0
    protocol ="1"
    cidr_blocks=["0.0.0.0/0"]

}
tags = {
  Name = "bastion-sg"
}
}

#sonarqube securitygroup
resource "aws_security_group" "sonarqube_sg" {
    name = "sonarqube_sg"
    description = "sonarqube security group"
    vpc_id = var.vpc_id

    ingress  {
        description     = "ssh access"
        from_port       = 22
        to_port         = 22
        protocol        = "TCP"
        cidr_blocks     = [ "0.0.0.0/0"]
    }
    ingress {
        description = "sonarqube-port"
        from_port = 9000
        to_port = 9000
        protocol = "TCp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP-port"
        from_port = 80
        to_port   = 80
        protocol  = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTPS-port"
        from_port = 443
        to_port   = 443
        protocol  = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress{
        from_port = 0
        to_port  = 0
        protocol = "1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags   = {
      Name = "sonarqube-sg"
    }
    
  
}

#nexus secruity group
resource "aws_security_group" "jenkins_sg" {
    name = "jenkins-sg"
    description = "jenkins securtity group "
    vpc_id = var.vpc_id

    ingress {
        description = "ssh access"
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "jenkins-port"
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }


ingress {
    description = "HTTPs"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0"]
}
ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
}
tags = {
  Name = "jenkins-sg"
}
}

resource "aws_security_group" "ansible_sg" {
    name = "ansible-sg"
    description = "ansible security group"
    vpc_id = var.vpc_id 


ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    ="tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {
    from_port= 0
    to_port =0
    protocol ="1"
    cidr_blocks=["0.0.0.0/0"]

}
tags = {
  Name = "ansible-sg"
}
}

#nexus secruity group
resource "aws_security_group" "nexus_sg" {
    name = "nexus-sg"
    description = "nexus securtity group "
    vpc_id = var.vpc_id

    ingress {
        description = "ssh access"
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "nexus-port"
        from_port = 8081
        to_port = 8081
        protocol = "TCP"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

ingress {
    description = "nexus-port"
    from_port = 8085
    to_port = 8085
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
}
ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0"]
}
ingress {
    description = "https"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
}
tags = {
  Name = "nexus-sg"
}
}

#asg scurity group 
resource "aws_security_group" "asg-sg" {
    name = "asg-sg"
    description = "asg securtity group "
    vpc_id = var.vpc_id

    
    ingress {
        description = "ssh access"
        from_port = 22
        to_port = 22
        protocol = "TCP"
       cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        description = "port 1"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }


ingress {
    description = "HTTPs"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0"]
}
ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
}
tags = {
  Name = "asg-sg"
}
}


#create rds security group
resource "aws_security_group" "rds-sg" {
    name = "rds-sg"
    description = "rds security group"
    vpc_id = var.vpc_id 


ingress {
    description = "ssh access"
    from_port   = 3306
    to_port     = 3306
    protocol    ="tcp"
    security_groups =[ aws_security_group.bastion_sg.id, aws_security_group.asg-sg.id]
}
egress {
    from_port= 0
    to_port =0
    protocol ="1"
    cidr_blocks=["0.0.0.0/0"]

}
tags = {
  Name = "rds-sg"
}
}