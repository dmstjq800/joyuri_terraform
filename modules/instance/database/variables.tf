variable "private_db_subnet_id" {
  description = "db_subnet_id"
  type = list(string)
}
variable "availability_zone" {
  description = "zone of ap-northeast-2"
  type = list(string)
  default = [ "ap-northeast-2a", "ap-northeast-2c" ]
}
variable "security_group_id" {
  description = "security_group_id"
  type = string
}
variable "username" {
  description = "root_username"
  type = string
  default = "root"
  sensitive = true
}
variable "password" {
  description = "root_password"
  type = string
  default = "password"
  sensitive = true
}