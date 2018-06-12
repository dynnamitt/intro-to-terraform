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

# remote api query - TESING
data "aws_vpc" "selected" {
  filter {
    name   = "tag:Environment"
    values = ["${var.labenv}"]
  }
}

# local disk relative, NOT in use now
# data "terraform_remote_state" "x" {
#   backend = "local"
#
#   config {
#     path = "../single-web-server/terraform.tfstate"
#   }
# }

# new remote version
data "terraform_remote_state" "r_state" {
  backend = "s3"

  config {
    bucket = "tfstate-bf-kmidtlie"
    key    = "single-web-server/terraform.tfstate"
    region = "${var.region}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SECURITY GROUP THAT'S APPLIED TO THE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "sg" {
  name   = "sg-java-mc"
  vpc_id = "${data.aws_vpc.selected.id}"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Environment = "${var.labenv}"
  }
}

resource "aws_security_group" "sg2" {
  name   = "sg-java-mc-test2"
  vpc_id = "${data.terraform_remote_state.r_state.vpc_id}"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Environment = "${var.labenv}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A SINGLE EC2 INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "java-mc" {
  # Ubuntu Server 14.04 LTS (HVM), SSD Volume Type in us-east-1
  ami                    = "ami-2d39803a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  tags {
    Name        = "terraform-example-2"
    Environment = "${var.labenv}"
  }
}
