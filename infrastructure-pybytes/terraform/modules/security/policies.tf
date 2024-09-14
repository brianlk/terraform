resource "aws_iam_policy" "s3_pyconfig_ro" {
  name = "${var.tenant}-${var.environment}-s3-pyconfig-staging-ro"
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
          "arn:aws:s3:::pyconfig-${var.tenant}-${var.environment}/*",
          "arn:aws:s3:::pyconfig-${var.tenant}-${var.environment}"
        ]
      }
    ]
  })
}


resource "aws_iam_policy" "s3_apps_theme_ro" {
  name = "${var.tenant}-${var.environment}-s3-apps-theme-ro"
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
          "arn:aws:s3:::apps-theme-${var.tenant}-${var.environment}/*",
          "arn:aws:s3:::apps-theme-${var.tenant}-${var.environment}"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "s3_apps_config_ro" {
  name = "${var.tenant}-${var.environment}-s3-apps-config-ro"
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
          "arn:aws:s3:::apps-config-${var.tenant}-${var.environment}/*",
          "arn:aws:s3:::apps-config-${var.tenant}-${var.environment}"
        ]
      }
    ]
  })
}


resource "aws_iam_policy" "secrets_ro" {
  name = "${var.tenant}-${var.environment}-secrets-ro"
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
        "Resource" : "arn:aws:secretsmanager:*:815345548820:secret:${var.tenant}/*"
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          "arn:aws:secretsmanager:*:815345548820:secret:pycom/*"
        ]
      }
    ]
  })
}
