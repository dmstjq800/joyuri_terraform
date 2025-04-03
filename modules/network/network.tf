##################################
# VPC 생성
resource "aws_vpc" "myVPC" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "myvpc"
  }
}
################################
# Public Subnet 생성
resource "aws_subnet" "myPublicSN" {
  count = length(var.public_sn_cidr)
  vpc_id = aws_vpc.myVPC.id
  cidr_block = var.public_sn_cidr[count.index]
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "Public-SN-${count.index+1}"
  }
}
##############################
# Private Subnet 생성
resource "aws_subnet" "myPrivateSN" {
  count = length(var.private_sn_cidr)
  vpc_id = aws_vpc.myVPC.id
  cidr_block = var.private_sn_cidr[count.index]
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "Private-SN-${count.index+1}"
  }
}
#############################
# DB subnet 생성
resource "aws_subnet" "myPrivateDBSN" {
  count = length(var.private_dbsn_cidr)
  vpc_id = aws_vpc.myVPC.id
  cidr_block = var.private_dbsn_cidr[count.index]
  availability_zone = element(var.availability_zone, count.index)
  tags = {
    Name = "Private-DBSN-${count.index+1}"
  }
}
###############################
# IGW 생성
resource "aws_internet_gateway" "myIGW" {
  vpc_id = aws_vpc.myVPC.id
  tags = {
    Name = "myigw"
  }
}
###############################
# Public Subnet 라우팅테이블 생성 및 연결
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.myVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myIGW.id
  }
  tags = {
    Name = "public-route-table"
  }
}
resource "aws_route_table_association" "public_route_table_association" {
  count = length(var.public_sn_cidr)
  subnet_id = aws_subnet.myPublicSN[count.index].id 
  route_table_id = aws_route_table.public_route_table.id 
}
#############################
# EIP 생성
resource "aws_eip" "myEIP" {
  tags = {
    Name = "eip"
  }
}
#############################
# NAT 게이트웨이 생성
resource "aws_nat_gateway" "myNAT" {
  allocation_id = aws_eip.myEIP.id 
  subnet_id = aws_subnet.myPublicSN[0].id 
  tags = {
    Name = "mynat"
  }
}
#############################
# Private Subnet 라우팅테이블 생성 및 연결
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.myVPC.id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.myNAT.id 
  }
  tags = {
    Name = "private-route-table"
  }
}
resource "aws_route_table_association" "private_route_table_association" {
  count = length(var.private_sn_cidr)
  subnet_id = aws_subnet.myPrivateSN[count.index].id 
  route_table_id = aws_route_table.private_route_table.id
}