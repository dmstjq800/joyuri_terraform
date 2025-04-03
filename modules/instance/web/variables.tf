variable "vpc_id" {
  description = "vpc_id"
  type = string
}
variable "vpc_security_group_id" {
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
}
variable "was_dns" {
  description = "web_dns"
  type = string
}