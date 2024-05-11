locals {
  #Region
  region = "us-east-1"

  #VPC

  vpc_cidr           = "10.0.0.0/16"
  vpc_azs            = ["us-east-1a", "us-east-1b"]
  vpc_subnets_per_az = 1 #With RDS change to 2

  vpc_private_subnet_cidrs = flatten(
    [for k, v in local.vpc_azs : [
      for i in range(local.vpc_subnets_per_az) : cidrsubnet(local.vpc_cidr, 8, 2 * i + k + 1)
      ]
    ]
  )

  vpc = {
    private_subnet_names        = [for k, v in local.vpc_private_subnet_cidrs : "private_subnet_${k}"]
    lambda_private_subnet_cidrs = [for i in range(length(local.vpc_azs)) : local.vpc_private_subnet_cidrs[i]]
    # database_private_subnet_cidrs = [for i in range(length(local.vpc_azs)) : local.vpc_private_subnet_cidrs[i + length(local.vpc_azs)]]
    endpoint_service_names = {
      s3     = "com.amazonaws.${local.region}.s3",
      dynamo = "com.amazonaws.${local.region}.dynamodb"
    }
  }
  #Datasources
  account_id = data.aws_caller_identity.current.account_id

  #IAM
  lab_role = "arn:aws:iam::${local.account_id}:role/LabRole"

  lambda_security_group_description = "Default Lambda Security Group"

  lambda_functions_source_files = [for lambda_function_filename in fileset("${var.lambda_functions_paths.source}/*", "*.py") :
    {
      source_path = "${var.lambda_functions_paths.source}/${lambda_function_filename}"
      output_path = "${var.lambda_functions_paths.output}/${replace(lambda_function_filename, ".py", ".zip")}"
    }
  ]
  lambda = {
    functions_attributes = {
      get_expenses = {
        function_name    = "getExpenses"
        filename         = "${var.lambda_functions_paths.output}/getExpenses.zip"
        description      = "Get all expenses"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "getExpenses.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "expenses"
        }
      }
      post_expenses = {
        function_name    = "postExpenses"
        filename         = "${var.lambda_functions_paths.output}/postExpenses.zip"
        description      = "Create a new expense"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "postExpenses.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "expenses"
          BUCKET_NAME = module.bucket_s3["website_bucket"].s3_bucket_id
          BUCKET_DOMAIN = module.bucket_s3["website_bucket"].domain_name
        }
      }
      put_expenses = {
        function_name    = "putExpenses"
        filename         = "${var.lambda_functions_paths.output}/putExpenses.zip"
        description      = "Modify an expense"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "putExpenses.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "expenses"
          BUCKET_NAME = module.bucket_s3["website_bucket"].s3_bucket_id
          BUCKET_DOMAIN = module.bucket_s3["website_bucket"].domain_name
        }
      }
      delete_expenses = {
        function_name    = "deleteExpenses"
        filename         = "${var.lambda_functions_paths.output}/deleteExpenses.zip"
        description      = "Delete an expense"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "deleteExpenses.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "expenses"
          BUCKET_NAME = module.bucket_s3["website_bucket"].s3_bucket_id
        }
      }
      get_budgets = {
        function_name    = "getBudgets"
        filename         = "${var.lambda_functions_paths.output}/getBudgets.zip"
        description      = "Get all budgets"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "getBudgets.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "budgets"
        }
      }
      post_budgets = {
        function_name    = "postBudgets"
        filename         = "${var.lambda_functions_paths.output}/postBudgets.zip"
        description      = "Create a new budget"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "postBudgets.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "budgets"
          BUCKET_NAME = module.bucket_s3["budget_bucket"].s3_bucket_id
          BUCKET_DOMAIN = module.bucket_s3["budget_bucket"].domain_name
        }
      }
      put_budgets = {
        function_name    = "putBudgets"
        filename         = "${var.lambda_functions_paths.output}/putBudgets.zip"
        description      = "Modify a budget"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "putBudgets.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "budgets"
          URL = "https://www.clouditba.com.ar" 
          BUCKET_NAME = module.bucket_s3["budget_bucket"].s3_bucket_id
          BUCKET_DOMAIN = module.bucket_s3["budget_bucket"].domain_name
          SNS_TOPIC_ARN = module.sns.sns_topic_arn
        }
      }
      delete_budgets = {
        function_name    = "deleteBudgets"
        filename         = "${var.lambda_functions_paths.output}/deleteBudgets.zip"
        description      = "Delete a budget"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "deleteBudgets.lambda_handler"
        timeout          = 10
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "budgets"
          BUCKET_NAME = module.bucket_s3["budget_bucket"].s3_bucket_id
        }
      }

      add_budgets_email_subscriber  = {
        function_name    = "addBudgetsEmailSubscriber"
        filename         = "${var.lambda_functions_paths.output}/addBudgetsEmailSubscriber.zip"
        description      = "Add subscribers to a budget"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "addBudgetsEmailSubscriber.lambda_handler"
        timeout          = 20
        environment_variables = {
          REGION              = local.region
          DYNAMODB_TABLE_NAME = "budgets"
          SUBSCRIPTORS_TABLE_NAME= "subscriptions"
          BUCKET_NAME = module.bucket_s3["budget_bucket"].s3_bucket_id
          SNS_TOPIC_ARN = module.sns.sns_topic_arn
          VPC_ENDPOINT = module.network.vpc_endpoint_id
        }
      }

      get_expense_file = {
        function_name    = "getExpenseFile"
        filename         = "${var.lambda_functions_paths.output}/getExpenseFile.zip"
        description      = "Get expense file"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "getExpenseFile.lambda_handler"
        timeout          = 20
        environment_variables = {
          REGION              = local.region
          BUCKET_NAME = module.bucket_s3["website_bucket"].s3_bucket_id
        }
      }
      get_budget_file = {
        function_name    = "getBudgetFile"
        filename         = "${var.lambda_functions_paths.output}/getBudgetFile.zip"
        description      = "Get budget file"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "getBudgetFile.lambda_handler"
        timeout          = 20
        environment_variables = {
          REGION              = local.region
          BUCKET_NAME = module.bucket_s3["budget_bucket"].s3_bucket_id
          DYNAMODB_TABLE_NAME = "budgets"
          SUBSCRIPTIONS_TABLE_NAME = "subscriptions"
        }
      }

      update_version_budget = {
        function_name    = "updateVersionBudget"
        filename         = "${var.lambda_functions_paths.output}/updateVersionBudget.zip"
        description      = "Update Budget Version"
        source_code_hash = ""
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "updateVersionBudget.lambda_handler"
        timeout          = 20
        environment_variables = {
          REGION              = local.region
          SUBSCRIPTORS_TABLE_NAME= "subscriptions"
          URL = "https://www.clouditba.com.ar" 
          BUCKET_NAME = module.bucket_s3["budget_bucket"].s3_bucket_id
          DYNAMODB_TABLE_NAME = "budgets"
          SNS_TOPIC_ARN = module.sns.sns_topic_arn
        }
      }
    }
    private_subnet_ids = [for i, private_subnet_cidr in local.vpc.lambda_private_subnet_cidrs : module.network.vpc_private_subnets_ids_by_cidr[private_subnet_cidr]]
  }


  #API Gateway
  api_gateway = {
    source_arn = "${module.api_gateway.rest_api.execution_arn}/*"
    stage_name = "/${local.api_gateway_rest_api_info.stage_name}"
  }

  api_gateway_config = {
    cognito_user_pool_arn = module.cognito["email_authentication_pool"].user_pool_arn
    authorizer_name       = "CognitoAuthorizer"
  }

  api_gateway_rest_api_info = {
    name        = "moneyorganizer REST API"
    description = "REST API functions for money management operations"
    stage_name  = "development"
    base_path   = "api"
  }
  api_gateway_resources = {
    expenses = {
      path_part = "expenses"
    }
    budgets = {
      path_part = "budgets"
    }
    subscriber = {
      path_part = "subscriber"
    }
    expense_file = {
      path_part = "expense_file"
    }
    budget_file = {
      path_part = "budget_file"
    }
  }
  api_gateway_methods = {
    get_expenses = {
      resource      = "expenses"
      method        = "GET"
      authorization = "COGNITO_USER_POOLS"
    }
    post_expenses = {
      resource      = "expenses"
      method        = "POST"
      authorization = "COGNITO_USER_POOLS"
    }
    put_expenses = {
      resource      = "expenses"
      method        = "PUT"
      authorization = "COGNITO_USER_POOLS"
    }

    delete_expenses = {
      resource      = "expenses"
      method        = "DELETE"
      authorization = "COGNITO_USER_POOLS"
    }

    get_budgets = {
      resource      = "budgets"
      method        = "GET"
      authorization = "COGNITO_USER_POOLS"
    }

    post_budgets = {
      resource      = "budgets"
      method        = "POST"
      authorization = "COGNITO_USER_POOLS"
    }

    put_budgets = {
      resource      = "budgets"
      method        = "PUT"
      authorization = "COGNITO_USER_POOLS"
    }

    delete_budgets = {
      resource      = "budgets"
      method        = "DELETE"
      authorization = "COGNITO_USER_POOLS"
    }

    add_budgets_email_subscriber = {
      resource      = "subscriber"
      method        = "POST"
      authorization = "COGNITO_USER_POOLS"
    }

    get_expense_file = {
      resource      = "expense_file"
      method        = "POST"
      authorization = "COGNITO_USER_POOLS"
    }

    get_budget_file = {
      resource      = "budget_file"
      method        = "POST"
      authorization = "COGNITO_USER_POOLS"
    }

    update_version_budget = {
      resource      = "budget_file"
      method        = "PUT"
      authorization = "COGNITO_USER_POOLS"
    }
  }

  #s3 buckets:
  buckets = {
    website_bucket = {
      bucket_name        = var.bucket_name
      bucket_policy_read = true
      identifiers        = [module.cdn.OAI]
      actions            = ["s3:GetObject"]
      objects = [
        {
          key          = "index.html"
          source       = "./frontend/index.html"
          content_type = "text/html"
        }
      ]
    }
    logs_bucket = {
      bucket_name = "${var.bucket_name}-logs"
      logs        = var.bucket_name
      lifecycle_rule = [
        {
          id      = "log-lifecycle"
          enabled = true
          prefix  = "log/"

          tags = {
            rule      = "log"
            autoclean = "true"
          }

          transition = [
            {
              days          = 30
              storage_class = "STANDARD_IA"
            },
            {
              days          = 60
              storage_class = "GLACIER"
            }
          ]

          expiration = {
            days = 90
          }

          noncurrent_version_expiration = {
            days = 30
          }
        }
      ]
    }
    budget_bucket = {
      bucket_name        = var.bucket_budget_name
      bucket_policy_read = true
      versioning         = "Enabled"
      identifiers        = ["*"]
      vpc_ids            = [module.network.vpc_endpoints[local.vpc.endpoint_service_names.s3].id]
      actions            = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
      lifecycle_rule = [
        {
          id      = "budget-lifecycle"
          enabled = true
          prefix  = "budget/"

          transition = [
            {
              days          = 180
              storage_class = "STANDARD_IA"
            },
            {
              days          = 360
              storage_class = "GLACIER"
            }
          ]

          expiration = {
            days = 600
          }
        }
      ]
    }
  }

  # Cognito

  cognito_user_pools = {
    email_authentication_pool = {
      username_attributes = ["email"]
      cognito_domain      = "moneyorganizer"
      schemas = [
        {
          attribute_data_type      = "String"
          developer_only_attribute = false
          mutable                  = false
          name                     = "email"
          required                 = true
        }
      ]
      client_config = [
        {
          name                   = "CognitoEmailClient"
          read_attributes        = ["email"]
          write_attributes       = ["email"]
          auth_flows             = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH"]
          generate_secret        = false
          access_token_validity  = 60
          id_token_validity      = 60
          refresh_token_validity = 30
          domain_name            = "https://duqc1lmp8w5yr.cloudfront.net"
          token_validity_units = {
            access_token  = "minutes"
            id_token      = "minutes"
            refresh_token = "days"
          }
        },
      ]
    }
  }

  #DynamoDB
  dynamodb_tables = {
    expenses = {
      partition_key = "user_id"
      sort_key      = "id"

      local_secondary_indexes = [
        {
          name      = "DateIndex"
          range_key = "date"
        },
        {
          name      = "CategoryIndex"
          range_key = "category"
        },
        {
          name      = "AmountIndex"
          range_key = "amount"
        },
      ]

      attributes = [
        {
          name = "user_id"
          type = "S"
        },
        {
          name = "id"
          type = "S"
        },
        {
          name = "date"
          type = "N"
        },
        {
          name = "category"
          type = "S"
        },
        {
          name = "amount"
          type = "N"
        }
      ]
    }
    budgets = {
      partition_key = "user_id"
      sort_key      = "id"

      attributes = [
        {
          name = "user_id"
          type = "S"
        },
        {
          name = "id"
          type = "S"
        }
      ]
    }
    subscriptions = {
      partition_key = "email"
      sort_key      = "budget_id"

      attributes = [
        {
          name = "email"
          type = "S"
        },
        {
          name = "budget_id"
          type = "S"
        }
      ]
    }
  }

}