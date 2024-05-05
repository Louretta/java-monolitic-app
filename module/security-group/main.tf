#Bastion security group 
resource "aws_security_group" "bastion_sg" {
    name = "bastion_sg"
    description = "bastion security group"
    vpc_id = var.vpc_id 


ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    ="tcp"
    cidr_blocks = ["0.0.0.0.0/0"]
}
egress {
    from_port= 0
    to_port =0
    protocol ="1"
    cidr_blocks=["0.0.0.0/0"]

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
    
  
}

#nexus secruity group
resource "aws_security_group" "nexus_sg" {
    name = "nexus_sg"
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
  Name = "nexus_sg"
}
}