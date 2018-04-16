# output "public_ip" {
#   value = "${aws_instance.example.public_ip}"
# }

output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "subnets" {
  value = "${local.my_vpc["p_subnets"]}"
}
