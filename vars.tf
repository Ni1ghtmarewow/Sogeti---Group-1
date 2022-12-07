# Defining Region
variable "aws_region" {
  default = "eu-west-1"
}

# Defining CIDR Block for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Defining CIDR Block for second VPC
variable "vpc2_cidr" {
  default = "10.1.0.0/16"
}

# Defining CIDR Block for Subnet
variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

# Defining CIDR Block for 2d Subnet
variable "subnet1_cidr" {
  default = "10.0.2.0/24"
}

# Defining CIDR Block for 3d Subnet
variable "private_subnet_cidr" {
  default = "10.1.1.0/24"
}

# Defining CIDR Block for 4d Subnet
variable "private_subnet1_cidr" {
  default = "10.1.2.0/24"
}

# Defining Master count 
variable "master_count" {
  default = 1
}