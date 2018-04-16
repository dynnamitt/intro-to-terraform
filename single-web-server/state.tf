# Because of the assume_role defined in provider,
# the last 3 lines should not be required.
# For some reason the authentication failed without it
# See https://github.com/hashicorp/terraform/issues/13589
terraform {
  backend "s3" {
    bucket = "tfstate-bf-kmidtlie"
    key    = "single-web-server/terraform.tfstate"

    #dynamodb_table = "tfstatelock-bf-ruter-test"
    region = "eu-west-1"

    # role_arn       = "arn:aws:iam::822152007605:role/admin"
    # session_name   = "BF-AWSOps"
    # external_id    = "BF-NO-11978"
  }
}
