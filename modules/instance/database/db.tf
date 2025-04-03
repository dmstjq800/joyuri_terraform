###################
# DB Subnet Group 생성
resource "aws_db_subnet_group" "mydbsn_group" {
  name = "db-subnet-group"
  subnet_ids = var.private_db_subnet_id
  tags = {
    Name = "db-subnet-group"
  }
}
###################
# RDS Cluster 생성
resource "aws_rds_cluster" "myRDS_Cluster" {
  # DB Subnet Group
  db_subnet_group_name = aws_db_subnet_group.mydbsn_group.name 
  cluster_identifier = "mycluster"
  engine = "aurora-mysql"
  engine_version = "5.7.mysql_aurora.2.11.5"
  engine_mode = "provisioned"
  database_name = "project_dev"

  availability_zones = var.availability_zone
  master_username = var.username 
  master_password = var.password 
  vpc_security_group_ids = [ var.security_group_id ]
  skip_final_snapshot = true 
  port = 3306
}
##############################
# RDS Instance 생성
resource "aws_rds_cluster_instance" "myRDS_Instance" {
  count = 1
  identifier = "db-${count.index+1}"
  cluster_identifier = aws_rds_cluster.myRDS_Cluster.id 
  instance_class = "db.t3.small"
  engine = aws_rds_cluster.myRDS_Cluster.engine 
  engine_version = aws_rds_cluster.myRDS_Cluster.engine_version
}