output "nexus_elb_dns_name" {
    value = aws_elb.nexus_elb.dns_name
  
}
output "nexus_elb_zone_id" {
    value = aws_elb.nexus_elb.zone_id
  
}
output "nexus_public_ip" {
    value = aws_instance.nexus.public_ip
  
}