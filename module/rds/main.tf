# Database Subnet Group
resource "aws_db_subnet_group" "db-subnet-group" {
  name = var.db-subnet-grp
  subnet_ids = var.subnet
  tags = {
    Name = var.tag-name
  } 
}


# MySQL RDS database
resource "aws_db_instance" "rds-database"{
  identifier             = "petclinic"
  db_subnet_group_name   = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids = [var.security_group_mysql_sg]
  publicly_accessible    = true
  skip_final_snapshot    = true
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = var.db-name
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = "default.mysql5.7"
  storage_type           = "gp2"
}
