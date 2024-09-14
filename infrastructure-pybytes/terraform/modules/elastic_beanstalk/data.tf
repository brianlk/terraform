data "aws_elastic_beanstalk_solution_stack" "node14" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) running Node.js 14(.*)$"
}

data "aws_elastic_beanstalk_solution_stack" "node18" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) running Node.js 18(.*)$"
}
