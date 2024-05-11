resource "aws_cognito_user_pool" "pool" {
  name = var.user_pool_name

  username_attributes = var.username_attributes
  auto_verified_attributes = var.username_attributes

  deletion_protection = "INACTIVE"

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  dynamic "schema" {
    for_each = var.schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")
    }
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
  }
}

resource "aws_cognito_user_pool_domain" "pool" {
  domain       = var.cognito_domain
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  user_pool_id = aws_cognito_user_pool.pool.id
  count        = length(var.client_config)

  explicit_auth_flows           = var.client_config[count.index].auth_flows
  generate_secret               = var.client_config[count.index].generate_secret
  name                          = var.client_config[count.index].name
  read_attributes               = var.client_config[count.index].read_attributes
  write_attributes              = var.client_config[count.index].write_attributes
  access_token_validity         = var.client_config[count.index].access_token_validity
  id_token_validity             = var.client_config[count.index].id_token_validity
  refresh_token_validity        = var.client_config[count.index].refresh_token_validity
  prevent_user_existence_errors = "ENABLED"
  callback_urls = [var.client_config[count.index].domain_name]
  logout_urls = [var.client_config[count.index].domain_name]



  dynamic "token_validity_units" {
    for_each = var.client_config[count.index].token_validity_units == null ? [] : [1]
    content {
      access_token  = lookup(var.client_config[count.index].token_validity_units, "access_token")
      id_token      = lookup(var.client_config[count.index].token_validity_units, "id_token")
      refresh_token = lookup(var.client_config[count.index].token_validity_units, "refresh_token")
    }
  }
}