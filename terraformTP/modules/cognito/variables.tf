variable "user_pool_name" {
  type        = string
  description = "Name of the Cognito User Pool"
}

variable "username_attributes" {
  type        = list(string)
  description = "Alias Attributes of the Cognito User Pool"
}

variable "cognito_domain"{
  type = string
  description = "Cognito Domain to verify account"
}

variable "schemas" {
  type = list(object({
    attribute_data_type      = string
    developer_only_attribute = bool
    mutable                  = bool
    name                     = string
    required                 = bool
  }))
  description = "Attributes to create the user in the user pool"
  default     = []
}

variable "client_config" {
  type = list(object({
    name                   = string
    read_attributes        = list(string)
    write_attributes       = list(string)
    auth_flows             = list(string)
    generate_secret        = bool
    access_token_validity  = number
    id_token_validity      = number
    refresh_token_validity = number
    domain_name            = string
    token_validity_units = object({
      access_token  = string
      id_token      = string
      refresh_token = string
    })
  }))
}