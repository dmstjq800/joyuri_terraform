variable "vpc_cidr" {
  description = "VPC_cidr"
  type = string
  default = "10.0.0.0/16"
}
variable "public_sn_cidr" {
  description = "public-subnet-cidr list"
  type = list(string)
}
variable "private_sn_cidr" {
  description = "private-subnet-cidr list"
  type = list(string)
}
variable "private_dbsn_cidr" {
  description = "-private-db-subent-cidr list"
  type = list(string)
}
variable "availability_zone" {
  description = "zone of ap-northeast-2"
  type = list(string)
  default = [ "ap-northeast-2a", "ap-northeast-2c" ]
}