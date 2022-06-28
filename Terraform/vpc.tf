
resource "aws_vpc" "lambda-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
    tags = {
    Name = "lambda-vpc"
  }
}
resource "aws_internet_gateway" "lambda-vpc-igw" {
  vpc_id = aws_vpc.lambda-vpc.id
  tags ={
    Name = "lambda-vpc-igw"
  }
}
resource "aws_route_table" "lambda-vpc-rt-pb" {
  
  vpc_id = aws_vpc.lambda-vpc.id
  route{
      cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lambda-vpc-igw.id
  }
  tags ={
    Name = "lambda-vpc-rt-pb"
  }
}


