output "sonarqube_ip" {
    value = module.sonarqube.sonarqube_ip
  
}
output "nexus_ip" {
    value = module.nexus.nexus_public_ip
  
}

output "bastion_ip" {
    value = module.bastion.bastion_ip
  
}
output "ansible_ip" {
  value = module.ansible.ansible_ip
}
output "jenkins" {
    value = module.jenkins.jenkins_ip
  
}