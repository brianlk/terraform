data "aws_elastic_beanstalk_solution_stack" "eb_linux_node_14" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux (.*) running Node.js 14(.*)$"
}
