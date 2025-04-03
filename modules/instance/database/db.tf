###################
# DB Subnet Group 생성
resource "aws_db_subnet_group" "mydbsn_group" {
  name = "db-subnet-group"
  subnet_ids = var.private_db_subnet_id
  tags = {
    Name = "db-subnet-group"
  }
}
# ###################
# # RDS Cluster 생성
# resource "aws_rds_cluster" "myRDS_Cluster" {
#   # DB Subnet Group
#   db_subnet_group_name = aws_db_subnet_group.mydbsn_group.name 
#   cluster_identifier = "mycluster"
#   engine = "aurora-mysql"
#   engine_version = "5.7.mysql_aurora.2.11.5"
#   engine_mode = "provisioned"
#   database_name = "project_dev"
  
#   availability_zones = var.availability_zone
#   master_username = var.username 
#   master_password = var.password 
#   vpc_security_group_ids = [ var.security_group_id ]
#   skip_final_snapshot = true 
#   port = 3306

#   serverlessv2_scaling_configuration {
#     min_capacity = 0.5
#     max_capacity = 1
#   }
# }
# ##############################
# # RDS Instance 생성
# resource "aws_rds_cluster_instance" "myRDS_Instance" {
#   count = 1
#   identifier = "db-${count.index+1}"
#   cluster_identifier = aws_rds_cluster.myRDS_Cluster.id 
#   instance_class = "db.t3.small"
#   engine = aws_rds_cluster.myRDS_Cluster.engine 
#   engine_version = aws_rds_cluster.myRDS_Cluster.engine_version
# }
resource "aws_db_instance" "my_mysql_instance" {
  identifier           = "my-lowcost-db"
  engine               = "mysql"
  engine_version       = "8.0.33"  # 최신 안정 버전
  instance_class       = "db.t4g.micro"  # 프리티어 대상
  allocated_storage    = 20
  max_allocated_storage = 100

  db_name              = "project_dev"
  username             = var.username
  password             = var.password
  port                 = 3306

  db_subnet_group_name     = aws_db_subnet_group.mydbsn_group.name
  vpc_security_group_ids   = [var.security_group_id]
  publicly_accessible      = false
  skip_final_snapshot      = true
  backup_retention_period  = 0

  storage_type             = "gp3"
  parameter_group_name = aws_db_parameter_group.utf8_param_group.name
  tags = {
    Name = "mysql"
    Env  = "dev"
  }
}
resource "aws_db_parameter_group" "utf8_param_group" {
  name   = "mysql-utf8mb4"
  family = "mysql8.0"
  description = "MySQL 8.0 UTF-8 Parameter Group"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_general_ci"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_connection"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_results"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_filesystem"
    value = "binary"
  }
}
