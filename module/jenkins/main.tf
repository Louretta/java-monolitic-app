resource "aws_instance" "jenkins" {
  ami                         = var.ami
  instance_type               = "t3.medium"
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.jenkins_sg]
  associate_public_ip_address = true
  user_data                   = local.jenkins_user_data

  tags = {
    Name = var.name
  }
}

resource "aws_elb" "jenkins-elb" {
    name = "jenkins-elb" 
    subnets = var.elb-subnets
    security_groups = [ var.jenkins_sg ]
    listener {
      instance_port = 8080
      instance_protocol = "HTTP"
      lb_port = 443
      lb_protocol = "HTTPS"
      ssl_certificate_id = var.cert-arn
      

    
    }

    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "TCP:8080"
      interval = 30
    }

    instances = [ aws_instance.jenkins.id]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    tags = {
      Name = "jenkins-elb"
    }
  
}