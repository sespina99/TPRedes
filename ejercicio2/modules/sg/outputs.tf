output "sg_for_elb_id" {
  description = "The ID of the security group for ELB"
  value       = aws_security_group.sg_for_elb.id
}

output "sg_for_ec2_id" {
  description = "The ID of the security group for EC2"
  value       = aws_security_group.sg_for_ec2.id
}