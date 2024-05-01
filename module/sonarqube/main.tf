resource "aws_instance" "sonarqube" {
    ami = var.ami
    instance_type = "t2.meduim"
    key_name = var.keypair
    subnet_id = var.subnet_id
    vpc_security_group_ids = [ var.sonarqube_sg ]
    associate_public_ip_address = true
    user_data = local.sonarqube_user_data

    tags = {
      Name = var. name 
    }
  
}

resource "aws_elb" "sonarqube_elb" {
    name = "elb_sonarqube" 
    subnets = var.elb-subnets
    source_security_group = [var.sonarqube_sg]
    listener {
      instance_port = 9000
      instance_protocol = "HTTP"
      lb_port = 443
      lb_protocol = "HTTPS"
      ssl_certificate_id = var.cert-arn
    }

    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "TCP:9000"
      interval = 30
    }

    instances = [ aws_instance.sonarqube ]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    tags = {
      Name = "sonarqube_elb"
    }
  
}