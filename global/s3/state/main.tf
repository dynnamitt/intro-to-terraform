provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = "tfstate-bf-kmidtlie"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name        = "Terraform state bucket"
    Environment = "${var.labenv}"
    CostCenter  = "${var.costcenter}"
  }
}

output "S_BUMP" {
  value = "migration-from-local-2-s3-fine"
}
