module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name      = var.name
  hash_key  = var.partition_key
  range_key = var.sort_key

  attributes = var.attributes

  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity

  local_secondary_indexes = [for index in var.local_secondary_indexes : merge(index, { projection_type = "ALL" })]

  tags = var.tags

  autoscaling_enabled = var.autoscaling
}