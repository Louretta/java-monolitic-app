resource "aws_instance" "nexus" {
    ami                    = var.ami
    instance_type          = "t2.medium"
    vpc_security_group_ids = [ var.nexus_sg]
    subnet_id              = var.subnet_id
    key_name               = var.keypair
    associate_public_ip_address = true
    user_data = local.nexus_user_data

    tags = {
      Name = var.name
    }
  
}

resource "aws_elb" "nexus_elb"{
    name = "nexus-elb"
    subnets = var.elb-subnet
    security_groups = [var.nexus_sg]
    listener {
      instance_port = 8081
      instance_protocol = "HTTP"
      lb_port = 443
      lb_protocol = "HTTPs"
      ssl_certificate_id = var.cert-arn
      
      
    }
    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout =3
      target = "TCP:8081"
      interval = 30
    }
    instances = ["aws_instance.nexus.id"]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    tags = {
      Name = "nexus-elb"
    }

    }
  
