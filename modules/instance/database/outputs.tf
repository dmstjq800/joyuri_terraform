# output "db_dns" {
#   value = aws_rds_cluster.myRDS_Cluster.endpoint
# }
# output "db_instance" {
#   value = aws_rds_cluster_instance.myRDS_Instance
# }
output "db_dns" {
  value = aws_db_instance.my_mysql_instance.endpoint
}
output "db_instance" {
  value = aws_db_instance.my_mysql_instance
}