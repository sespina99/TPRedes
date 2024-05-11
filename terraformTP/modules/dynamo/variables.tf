variable "name" {
  type        = string
  description = "Name of the DynamoDB Table"
}

variable "partition_key" {
  type        = string
  description = "Partition key of the DynamoDB Table"
}

variable "sort_key" {
  type        = string
  description = "Sort key of the DynamoDB Table"
}

variable "read_capacity" {
  type        = number
  description = "Read Capacity of the DynamoDB Table"
  default     = null
}


variable "write_capacity" {
  type        = number
  description = "Write Capacity of the DynamoDB Table"
  default     = null
}


variable "attributes" {
  type        = list(map(string))
  description = "Attributes of the DynamoDB Table"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags for the DynamoDB Table"
  default     = {}
}

variable "autoscaling" {
  type        = bool
  description = "If autoscaling is ENABLED or DISABLED"
  default     = false
}

variable "local_secondary_indexes" {
  type = list(object({
    name      = string
    range_key = string
  }))
  description = "Local Secondary Indexes of the DynamoDB Table"
  default     = []
}