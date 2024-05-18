output "ansible_ip" {
    value = aws_instance.ansible.private_ip 
  
}