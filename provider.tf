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