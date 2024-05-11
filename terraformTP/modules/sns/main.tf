module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws" #external module
  version = "6.0.0"
  kms_master_key_id = aws_kms_key.sns_key.id 
}

resource "aws_kms_key" "sns_key" {
  description             = "KMS key for SNS encryption"
  deletion_window_in_days = 7
}

resource "aws_sns_topic_policy" "sns_lambda_policy" {
  arn    = module.sns_topic.topic_arn
  policy = data.aws_iam_policy_document.sns_lambda_policy.json
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = module.sns_topic.topic_arn
  protocol  = "email"
  endpoint  = "moneyorganizercloud@gmail.com"
}