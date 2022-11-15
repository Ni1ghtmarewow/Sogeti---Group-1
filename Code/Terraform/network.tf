# Create IGW
resource "aws_internet_gateway" "web-igw" {
    vpc_id = "${aws_vpc.web-vpc.id}"

    tags = {
        Name = "web-igw"
    }
}


# Add route to both routing tables (web / shared)
resource "aws_route_table" "web-rt" {
  vpc_id = "${aws_vpc.web-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.web-igw.id}"
  }
}

#resource "aws_route_table" "shared-rt" {
#  vpc_id = "${aws_vpc.shared-vpc.id}"
#
# route {
#    cidr_block = "0.0.0.0/0"
# }
#}


# Assosiate routing tables to VPC
resource "aws_route_table_association" "rt-assosiate-web-pub"{
    subnet_id = "${aws_subnet.web-pub.id}"
    route_table_id = "${aws_route_table.web-rt.id}"
}

#resource "aws_route_table_association" "rt-assosiate-database"{
#    subnet_id = "${aws_subnet.database.id}"
#    route_table_id = "${aws_route_table.shared-rt.id}"
#}


# Create security group for web-pub and database
resource "aws_security_group" "web-pub-security-group" {
    vpc_id = "${aws_vpc.web-vpc.id}"
    
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
    //If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "web-pub-security-group"
    }
}

resource "aws_security_group" "database-security-group" {
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
        cidr_blocks = ["10.2.0.0/16"]
    }

    tags = {
        Name = "database-security-group"
    }
}
