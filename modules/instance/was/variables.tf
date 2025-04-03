variable "vpc_id" {
  description = "vpc_id"
  type = string
}
variable "security_group_id" {
  description = "security-group-id"
  type = string
}
variable "private_subnet_id" {
  description = "private_subnet_id"
  type = list(string)
}
variable "iam_role_profile_arn" {
  description = "iam_instance_role_profile_arn"
  type = string
}
variable "db_dns" {
  description = "db_dns"
  type = string
}
variable "iam_code_deploy_arn" {
  description = "value"
  type = string
}
variable "front_dns" {
  description = "frontend_dns"
  type = string
}
variable "db_instance" {
  description = "RDS instance"
  type = string
}