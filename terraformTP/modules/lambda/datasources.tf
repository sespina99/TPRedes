data "archive_file" "lambda_package" {
  for_each       = var.lambda_functions_attributes
  type        = "zip"
  source_dir = "${var.lambda_functions_source_folder.source}/${each.value.function_name}/"
  output_path = "${var.lambda_functions_source_folder.output}/${each.value.function_name}.zip"
}