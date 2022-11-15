# Create website VPC and database VPC
resource "aws_vpc" "web-vpc" {
  cidr_block = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "web-vpc"
  }
} 

resource "aws_vpc" "shared-vpc" {
  cidr_block = "10.2.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "shared-vpc"
  }
}



# Create website subnet and database subnet
resource "aws_subnet" "web-pub" {
  vpc_id = "${aws_vpc.web-vpc.id}"
  cidr_block = "10.1.254.0/24"
  availability_zone = "eu-west-1a"
  
  tags = {
    Name = "web-pub"
  }
}

resource "aws_subnet" "web-pub2" {
  vpc_id = "${aws_vpc.web-vpc.id}"
  cidr_block = "10.1.253.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "web-pub2"
  }
}

resource "aws_subnet" "web-pub3" {
  vpc_id = "${aws_vpc.web-vpc.id}"
  cidr_block = "10.1.252.0/24"
  availability_zone = "eu-west-1c"

  tags = {
    Name = "web-pub3"
  }
}


resource "aws_subnet" "database" {
  vpc_id = "${aws_vpc.shared-vpc.id}"
  cidr_block = "10.2.2.0/24"
  availability_zone = "eu-west-1a"
  
  tags = {
    Name = "database"
  }
}

