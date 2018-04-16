# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A SINGLE EC2 INSTANCE
# This template uses runs a simple "Hello, World" web server on a single EC2 Instance
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source          = "git@github.com:basefarm/bf_aws_mod_vpc"
  name            = "${var.environment}"
  cidr            = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  database_subnets = [] #["10.1.201.0/24", "10.1.202.0/24", "10.1.203.0/24"]
  staticip_subnets = [] #["10.1.254.0/26", "10.1.254.64/26", "10.1.254.128/26"]

  create_nat_gateway = "false"
  create_vgw         = "true"

  # disabled if empty
  flowlogs_s3_bucket = ""

  tags {
    "CostCenter"  = "${var.costcenter}"
    "Environment" = "${var.environment}"
  }
}

locals {
  x = 1

  my_vpc = {
    p_subnets = "${module.vpc.private_subnets}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A SINGLE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

# resource "aws_instance" "example" {
#   # Ubuntu Server 14.04 LTS (HVM), SSD Volume Type in us-east-1
#   ami                    = "ami-2d39803a"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = ["${aws_security_group.instance.id}"]
#
#   user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello, World" > index.html
#               nohup busybox httpd -f -p "${var.server_port}" &
#               EOF
#
#   tags {
#     Name = "terraform-example"
#   }
# }

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "instance" {
  name   = "terraform-example-instance"
  vpc_id = "${module.vpc.vpc_id}"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "CostCenter"  = "${var.costcenter}"
    "Environment" = "${var.environment}"
  }
}
