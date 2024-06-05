output "ec2_primary_ip" {
  value = module.ec2.public_ip_primary
}

output "ec2_secondary_ip" {
  value = module.ec2.public_ip_secondary
}