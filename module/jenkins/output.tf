output "jenkins_ip" {
    value = aws_instance.jenkins.public_ip
  
}

output "jenkins_elb_dns_name" {
    value = aws_elb.jenkins-elb.dns_name
  
}
output "jenkins_elb_zone_id" {
    value = aws_elb.jenkins-elb.zone_id
  
}