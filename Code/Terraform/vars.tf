variable "AWS_REGION" {    
    default = "eu-west-1"
}

variable "AMI" {
    default = {
        eu-west-1 = "ami-0ee415e1b8b71305f"
        secret_key = "bkvJtQfvnhYWCggAV8CZFiDce6ZT0hSBSaqeQ287"
    }
}
