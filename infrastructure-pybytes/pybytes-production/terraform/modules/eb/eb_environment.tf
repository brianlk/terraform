resource "aws_elastic_beanstalk_environment" "eb_pybytes" {
  for_each            = { for x in var.aws_eb_environments : x.id => x }
  name                = each.value["id"]
  cname_prefix        = each.value["id"]
  application         = aws_elastic_beanstalk_application.eb_application_production.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.eb_linux_node_14.name

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = var.aws_vpc_id
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = var.aws_vpc_subnet_id
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = true
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = var.aws_iam_app_role_name
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "aws-key-eb"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = each.value["id"] == "pybytes-mqtt" ? "${var.aws_eb_security_groups_id},${var.aws_mqtt_security_group_id}" : var.aws_eb_security_groups_id
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:sns:topics"
    name      = "Notification Endpoint"
    value     = "pybytes-notifications@pycom.io"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "ManagedActionsEnabled"
    value     = "false"
    resource  = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions"
    name      = "PreferredStartTime"
    value     = "Mon:10:00"
    resource  = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:managedactions:platformupdate"
    name      = "UpdateLevel"
    value     = "minor"
    resource  = ""
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = true
    resource  = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "arn:aws:iam::815345548820:role/aws-elasticbeanstalk-service-role"
    resource  = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
    resource  = ""
  }
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = each.value["instance_type"]
    resource  = ""
  }

  setting {
    name      = "ConfigDocument"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    resource  = ""
    value = jsonencode(
      {
        CloudWatchMetrics = {
          Environment = {
            ApplicationLatencyP10     = 60
            ApplicationLatencyP50     = 60
            ApplicationLatencyP75     = 60
            ApplicationLatencyP85     = 60
            ApplicationLatencyP90     = 60
            ApplicationLatencyP95     = 60
            ApplicationLatencyP99     = 60
            "ApplicationLatencyP99.9" = 60
            ApplicationRequests2xx    = 60
            ApplicationRequests3xx    = 60
            ApplicationRequests4xx    = 60
            ApplicationRequests5xx    = 60
            ApplicationRequestsTotal  = 60
            InstancesDegraded         = 60
            InstancesInfo             = 60
            InstancesNoData           = 60
            InstancesOk               = 60
            InstancesPending          = 60
            InstancesSevere           = 60
            InstancesUnknown          = 60
            InstancesWarning          = 60
          }
          Instance = {
            ApplicationLatencyP10     = null
            ApplicationLatencyP50     = null
            ApplicationLatencyP75     = null
            ApplicationLatencyP85     = null
            ApplicationLatencyP90     = null
            ApplicationLatencyP95     = null
            ApplicationLatencyP99     = null
            "ApplicationLatencyP99.9" = null
            ApplicationRequests2xx    = null
            ApplicationRequests3xx    = null
            ApplicationRequests4xx    = null
            ApplicationRequests5xx    = null
            ApplicationRequestsTotal  = null
            CPUIdle                   = 60
            CPUIowait                 = 60
            CPUIrq                    = 60
            CPUNice                   = 60
            CPUSoftirq                = 60
            CPUSystem                 = 60
            CPUUser                   = 60
            InstanceHealth            = 60
            LoadAverage1min           = 60
            LoadAverage5min           = 60
            RootFilesystemUtil        = 60
          }
        }
        Version = 1
      }
    )
  }

  lifecycle {
    ignore_changes = [tags_all["Name"], solution_stack_name]
  }
}


data "aws_instance" "eb_environment_ec2_instance" {
  # Query each eb instance to retrieve the id of the ec2 instance
  # It is needed to retrieve some of the parameters like private IP
  for_each    = { for x in var.aws_eb_environments : x.id => x }
  instance_id = aws_elastic_beanstalk_environment.eb_pybytes[each.value["id"]].instances[0]
}
