# TODO: Designate a cloud provider, region, and credentials
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

provider "aws" {
  access_key = ""
  secret_key = ""
  token = ""
  profile = "default"
  region  = "us-east-1"
}


# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "t2_instances" {
  count         = 4
  ami           = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0f74dc39e6e02d066"
  tags = {
    "Name" = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
# resource "aws_instance" "m4_instances" {
#   count         = 2
#   ami           = "ami-090fa75af13c156b4"
#   instance_type = "m4.large"
#   subnet_id     = "subnet-0f74dc39e6e02d066"
#   tags = {
#     "Name"    = "Udacity M4"
#   }
# }