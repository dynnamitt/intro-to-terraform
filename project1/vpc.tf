module "vpc" {
  source          = "git@github.com:basefarm/bf_aws_mod_vpc"
  name            = "${var.labenv}"
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
    "Environment" = "${var.labenv}"
  }
}
