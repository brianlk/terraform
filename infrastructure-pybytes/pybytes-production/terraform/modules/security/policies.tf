resource "aws_iam_policy" "s3_pyconfig_ro" {
  name = "pybytes-production-s3-pyconfig-ro"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::pyconfig-pybytes-production/*",
          "arn:aws:s3:::pyconfig-pybytes-production"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_apps_theme_ro" {
  name = "pybytes-production-s3-apps-theme-ro"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::apps-theme-pybytes-production/*",
          "arn:aws:s3:::apps-theme-pybytes-production"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_apps_config_ro" {
  name = "pybytes-production-s3-apps-config-ro"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::apps-config-pybytes-production/*",
          "arn:aws:s3:::apps-config-pybytes-production"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "secrets_ro" {
  name = "pybytes-production-secrets-ro"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:*:815345548820:secret:pybytes/*"
      }
    ]
  })
}
