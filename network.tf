# Create website VPC and database VPC
data "aws_availability_zones" "available" {
    #state = available
}

resource "aws_vpc" "demovpc" {
  provider = aws.main
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "CICD VPC"

  }
} 

resource "aws_vpc" "demovpc2" {
  cidr_block = "${var.vpc2_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "Second CICD VPC"
  }
}

# Creating Internet Gateway 
resource "aws_internet_gateway" "demogateway" {
  provider = aws.main
  vpc_id = "${aws_vpc.demovpc.id}"

  tags = {
    Name = "CICD IGW"
  }
}

# Grant the internet access to VPC by updating its main route table
resource "aws_route" "internet_access" {
  provider = aws.main
  route_table_id         = "${aws_vpc.demovpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.demogateway.id}"
}

# Create subnets for the first VPC
resource "aws_subnet" "cicdsubnet" {
  provider = aws.main
  #count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.demovpc.id}"
  cidr_block = "${var.subnet_cidr}"
  #availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  #availability_zone = "eu-west-1a"

  tags = {
    Name = "Subnet CICD"
  }
}

resource "aws_subnet" "cicdsubnet2" {
  provider = aws.main
  #count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.demovpc.id}"
  cidr_block = "${var.subnet1_cidr}"
  #availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  #availability_zone = "eu-west-1a"

  tags = {
    Name = "Subnet CICD 2"
  }
}

resource "aws_subnet" "privatesubnet" {
  #count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.demovpc2.id}"
  cidr_block = "${var.private_subnet_cidr}"
  #availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  
  tags = {
    Name = "Private Subnet CICD"
  }
}

resource "aws_subnet" "privatesubnet2" {
  #count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.demovpc2.id}"
  cidr_block = "${var.private_subnet1_cidr}"
  #availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  
  tags = {
    Name = "Private Subnet CICD 2"
  }
}