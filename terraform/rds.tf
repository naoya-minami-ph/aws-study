resource "aws_db_subnet_group" "main" {
  name        = "aws-study-db-subnet-group"
  description = "Created from Terraform"
  subnet_ids  = [aws_subnet.private_1a.id, aws_subnet.private_1c.id]
}

resource "aws_db_instance" "main" {
  allocated_storage                    = 20
  allow_major_version_upgrade          = false
  auto_minor_version_upgrade           = true
  instance_class                       = "db.t4g.micro"
  port                                  = 3306
  storage_type                         = "gp2"
  backup_retention_period              = 1
  username                             = "root"
  password                             = var.db_password
  backup_window                        = "22:00-23:00"
  maintenance_window                   = "sun:18:00-sun:19:00"
  db_name                              = "awsstudy"
  engine                               = "mysql"
  license_model                        = "general-public-license"
  db_subnet_group_name                 = aws_db_subnet_group.main.name
  vpc_security_group_ids               = [aws_security_group.rds.id]
  publicly_accessible                  = false
  skip_final_snapshot                  = true # 学習用途のため。本番ではfalse推奨

  tags = {
    Name = "aws-study-rds"
  }
}
