output "db_dns" {
  value = aws_rds_cluster.myRDS_Cluster.endpoint
}
output "db_instance" {
  value = aws_rds_cluster_instance.myRDS_Instance
}