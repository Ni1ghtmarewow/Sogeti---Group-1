# Create NAT subnet
resource "aws_subnet" "nat-pub" {
  vpc_id = "${aws_vpc.shared-vpc.id}"
  cidr_block = "10.2.254.0/24"
  availability_zone = "eu-west-1a"
  
  tags = {
    Name = "nat-pub"
  }
}

# Deploy NAT instance
resource "aws_instance" "nat1" {
    # Amazon machine image
    ami = "ami-0ee415e1b8b71305f"

    # Instance type
    instance_type = "t2.micro"
    
    # VPC
    subnet_id = "${aws_subnet.nat-pub.id}"
    
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.nat1-security-group.id}"]
    
    # the Public SSH key
    key_name = "Terraform_key"
    
    # IP address
    private_ip = "10.2.254.254"

    tags = {
        Name = "nat1"
    }
}

# Create security group for NAT instance
resource "aws_security_group" "nat1-security-group" {
    vpc_id = "${aws_vpc.shared-vpc.id}"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["10.2.0.0/16"]
    }


    tags = {
        Name = "nat1-security-group"
    }
}

# Assign Elastic IP
resource "aws_eip" "nat1-elastipIp" {
  instance = "${aws_instance.nat1.id}"
  vpc      = true
}

# Create IGW
resource "aws_internet_gateway" "shared-igw" {
    vpc_id = "${aws_vpc.shared-vpc.id}"

    tags = {
        Name = "shared-igw"
    }
}

# Create NAT routing table
resource "aws_route_table" "nat-rt" {
    vpc_id = "${aws_vpc.shared-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.shared-igw.id}"
    }
}

# Assosiate routing tables to subnet
resource "aws_route_table_association" "rt-assosiate-nat"{
    subnet_id = "${aws_subnet.nat-pub.id}"
    route_table_id = "${aws_route_table.nat-rt.id}"
}
