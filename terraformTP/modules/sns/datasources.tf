data "aws_iam_policy_document" "sns_lambda_policy" {

    statement {
        actions = [
        "sns:Publish",
        "sns:Subscribe",
        ]

        resources = [module.sns_topic.topic_arn]

        # Indicar que se aplica a funciones Lambda
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
    }
}