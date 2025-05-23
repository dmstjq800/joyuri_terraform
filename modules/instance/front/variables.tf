variable "vpc_id" {
  description = "vpc_id"
  type = string
}
variable "alb_security_group_id" {
  description = "alb_security_group_id"
  type = string
}
variable "security_group_id" {
  description = "security_group_id"
  type = string
}
variable "public_subnet_id" {
  description = "public_subnet_id"
  type = list(string)
}
variable "private_subnet_id" {
  description = "private_subnet_id"
  type = list(string)
}
variable "iam_role_profile_arn" {
  description = "iam_instance_profile_arn"
  type = string
}
variable "back_dns" {
  description = "backend_dns"
  type = string
}
variable "iam_code_deploy_arn" {
  description = "code deploy iam role"
  type = string
}