# Create EC2 instance for the website
resource "aws_instance" "www1" {
    # Amazon machine image
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    
    # Instance type
    instance_type = "t2.micro"
    
    # VPC
    subnet_id = "${aws_subnet.web-pub.id}"
    
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.web-pub-security-group.id}"]
    
    # the Public SSH key
    key_name = "Terraform_key"
    
    # IP address
    private_ip = "10.1.254.10"

    tags = {
        Name = "Web Server"
    }
}

# Assign EIP to EC2
resource "aws_eip" "web-pub-elastipIp" {
  instance = "${aws_instance.www1.id}"
  vpc      = true
}

resource "aws_instance" "db1" {
    # Amazon machine image
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    
    # Instance type
    instance_type = "t2.micro"
    
    # VPC
    subnet_id = "${aws_subnet.database.id}"
    
    # Security Group
    vpc_security_group_ids = ["${aws_security_group.database-security-group.id}"]
    
    # the Public SSH key
    key_name = "Terraform_key"
    # IP address
    private_ip = "10.2.2.41"

    tags = {
        Name = "Database"
    }
}
