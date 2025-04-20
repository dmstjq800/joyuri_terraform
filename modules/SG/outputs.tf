output "alb_security_group_id" {
  value = aws_security_group.albSG.id
}
output "front_security_group_id" {
  value = aws_security_group.frontSG.id
}
output "back_security_group_id" {
  value = aws_security_group.backSG.id 
}
output "db_security_group_id" {
  value = aws_security_group.DBSG.id
}
output "iam_role_profile_arn" {
  value = aws_iam_instance_profile.iamprofile.arn
}
output "iam_code_deploy_arn" {
  value = aws_iam_role.codedeploy_role.arn
}