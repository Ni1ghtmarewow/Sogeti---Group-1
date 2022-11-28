provider "aws" {
  region = "${var.aws_region}"
}

# Creating VPC
resource "aws_vpc" "demovpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "CICD VPC"
  }
}

# Creating Internet Gateway 
resource "aws_internet_gateway" "demogateway" {
  vpc_id = "${aws_vpc.demovpc.id}"
}

# Grant the internet access to VPC by updating its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.demovpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.demogateway.id}"
}

# Creating 1st subnet 
resource "aws_subnet" "cicdsubnet" {
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
  vpc_id                  = "${aws_vpc.demovpc.id}"
  cidr_block             = "${var.subnet1_cidr}"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-1b"

  tags = {
    Name = "CICD subnet 1"
  }
}

# Creating Security Group
resource "aws_security_group" "demosg" {
  name        = "CICD Security Group"
  description = "Demo Module"
  vpc_id      = "${aws_vpc.demovpc.id}"

  # Inbound Rules
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Splunk default port
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Replication Port
  ingress {
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Management Port
  ingress {
    from_port   = 4598
    to_port     = 4598
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingestion Port
  ingress {
    from_port   = 9997
    to_port     = 9997
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules
  # Internet access to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}