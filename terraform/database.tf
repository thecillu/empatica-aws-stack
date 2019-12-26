resource "aws_db_instance" "empatica_database" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.database_name
  username             = var.database_username
  password             = var.database_password
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.empatica.name
  vpc_security_group_ids = [aws_security_group.database.id]
  skip_final_snapshot = true
}
