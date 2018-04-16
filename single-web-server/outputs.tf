# output "public_ip" {
#   value = "${aws_instance.example.public_ip}"
# }

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

# just testing syntax
output "subnets" {
  value = "${local.my_vpc["p_subnets"]}"
}

# just testing syntax
output "S_BUMP" {
  value = "Migrated state from local to s3"
}
