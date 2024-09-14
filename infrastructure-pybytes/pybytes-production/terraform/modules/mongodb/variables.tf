variable "mongodb_project_id" {
  type        = string
  description = "Atlas project id"
}

variable "mongodb_databases" {
  type        = list(string)
  description = "MongoDB databases that will be authorized"
}

variable "aws_iam_role_arn" {
  type        = string
  description = "IAM role that will be authorized to access the cluster"
}
