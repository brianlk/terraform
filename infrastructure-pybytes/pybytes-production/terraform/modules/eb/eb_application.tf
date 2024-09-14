resource "aws_elastic_beanstalk_application" "eb_application_production" {
  name        = "pybytes-production"
  description = "pybytes production application"

  appversion_lifecycle {
    service_role = var.aws_iam_app_role_arn
  }

  lifecycle {
    ignore_changes = [tags_all["Name"], appversion_lifecycle]
  }

}
