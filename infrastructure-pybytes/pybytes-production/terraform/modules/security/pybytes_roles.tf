resource "aws_iam_role" "pybytes_app" {
  name = "pybytes-production-pybytes-app"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_instance_profile" "pybytes_app" {
  name = "pybytes-production-pybytes-app"
  role = aws_iam_role.pybytes_app.name
}

resource "aws_iam_role_policy_attachment" "attach_app_role_to_s3_apps_config_ro" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = aws_iam_policy.s3_apps_config_ro.arn
}

resource "aws_iam_role_policy_attachment" "attach_app_role_to_s3_apps_theme_ro" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = aws_iam_policy.s3_apps_theme_ro.arn
}

resource "aws_iam_role_policy_attachment" "attach_app_role_to_s3_pyconfig_ro" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = aws_iam_policy.s3_pyconfig_ro.arn
}


resource "aws_iam_role_policy_attachment" "attach_pybytes_app_role_to_secrets_ro" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = aws_iam_policy.secrets_ro.arn
}

resource "aws_iam_role_policy_attachment" "attach_pybytes_app_role_to_AWSElasticBeanstalkWebTier" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}


resource "aws_iam_role_policy_attachment" "attach_pybytes_app_role_to_AWSElasticBeanstalkMulticontainerDocker" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}


resource "aws_iam_role_policy_attachment" "attach_pybytes_app_role_to_AWSElasticBeanstalk_Associate_addresses_ec2" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = "arn:aws:iam::815345548820:policy/AWSElasticBeanstalk-Associate-addresses-ec2"
}


resource "aws_iam_role_policy_attachment" "attach_pybytes_app_role_to_AWSElasticBeanstalkWorkerTier" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "attach_pybytes_app_role_to_AWSCodeArtifactReadOnlyAccess" {
  role       = aws_iam_role.pybytes_app.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeArtifactReadOnlyAccess"
}
