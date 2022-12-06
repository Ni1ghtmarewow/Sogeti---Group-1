provider "aws" {
  access_key = "AKIA2EIRQRN5ROBCGUP7"
  secret_key = "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"
  alias = "main"
  #profile = "UniUser"
  region = "eu-central-1"
}

provider "aws" {
  region = "${var.aws_region}"
}

# Creating VPC
resource "aws_vpc" "demovpc" {
  provider = aws.main
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "CICD VPC"
  }
}

# Creating Internet Gateway 
resource "aws_internet_gateway" "demogateway" {
  provider = aws.main
  vpc_id = "${aws_vpc.demovpc.id}"
}

# Grant the internet access to VPC by updating its main route table
resource "aws_route" "internet_access" {
  provider = aws.main
  route_table_id         = "${aws_vpc.demovpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.demogateway.id}"
}

# Creating 1st subnet 
resource "aws_subnet" "cicdsubnet" {
  provider = aws.main
  vpc_id                  = "${aws_vpc.demovpc.id}"
  cidr_block             = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1a"

  tags = {
    Name = "CICD subnet"
  }
}

# Creating 2nd subnet 
resource "aws_subnet" "cicdsubnet2" {
  provider = aws.main
  vpc_id                  = "${aws_vpc.demovpc.id}"
  cidr_block             = "${var.subnet1_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1b"

  tags = {
    Name = "CICD subnet 1"
  }
}
