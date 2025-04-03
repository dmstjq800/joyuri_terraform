output "vpc_id" {
  value = aws_vpc.myVPC.id
}
output "public_subnet_id" {
  value = aws_subnet.myPublicSN[*].id 
}
output "private_subnet_id" {
  value = aws_subnet.myPrivateSN[*].id 
}
output "private_db_subnet_id" {
  value = aws_subnet.myPrivateDBSN[*].id
}