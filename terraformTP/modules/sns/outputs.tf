output "sns_topic_arn" {
  description = "arn of sns topic"
  value = module.sns_topic.topic_arn
}