output "ansible_ip" {
    value = aws_instance.ansible.public_ip
  
}