output "bastion_sg" {
    value = aws_security_group.bastion_sg.id
  
}
output "sonarqube_sg" {
    value = aws_security_group.sonarqube_sg.id
  
}
output "nexus_sg" {
  value = aws_security_group.nexus_sg.id
}