resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.bastion_sg]
  associate_public_ip_address = true
  user_data                   = local.bastion_user_data

  tags = {
    Name = var.name
  }
}