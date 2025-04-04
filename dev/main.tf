provider "aws" {
  region = "ap-northeast-2"
}
module "security_groups" {
  source = "../modules/SG"
  vpc_id = module.network.vpc_id
}
######################
# VPC, Subnet
module "network" {
  source = "../modules/network"
  public_sn_cidr = [ "10.0.1.0/24", "10.0.2.0/24" ]
  private_sn_cidr = [ "10.0.3.0/24", "10.0.4.0/24" ]
  private_dbsn_cidr = [ "10.0.5.0/24", "10.0.6.0/24" ]
}
##################### 
#apache2 WEB 
module "front" {
  source = "../modules/instance/front"
  vpc_id = module.network.vpc_id
  vpc_security_group_id = module.security_groups.web_security_group_id ## 보안그룹
  public_subnet_id = module.network.public_subnet_id ## Public Subnet ID
  private_subnet_id = module.network.private_subnet_id ## Private Subnet ID
  iam_role_profile_arn = module.security_groups.iam_role_profile_arn ## IAM ROLE
  back_dns = module.back.back_dns
  iam_code_deploy_arn = module.security_groups.iam_code_deploy_arn
}
# Tomcat WAS
module "back" {
  source = "../modules/instance/backend"
  vpc_id = module.network.vpc_id
  security_group_id = module.security_groups.was_security_group_id
  private_subnet_id = module.network.private_subnet_id
  iam_role_profile_arn = module.security_groups.iam_role_profile_arn

  front_dns = module.front.front_dns
  iam_code_deploy_arn = module.security_groups.iam_code_deploy_arn
  db_dns = module.DB.db_dns
  db_instance = module.DB.db_instance
}
#######################
# Mysql DB
module "DB" {
  source = "../modules/instance/database"
  private_db_subnet_id = module.network.private_db_subnet_id
  security_group_id = module.security_groups.db_security_group_id
}