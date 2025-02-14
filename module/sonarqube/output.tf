output "sonarqube_ip" {
    value = aws_instance.sonarqube.public_ip
}

output "sonarqube_elb_dns_name" {
    value = aws_elb.sonarqube-elb.dns_name
  
}

output "sonarqube_elb_zone_id" {
    value = aws_elb.sonarqube-elb.zone_id
  
}