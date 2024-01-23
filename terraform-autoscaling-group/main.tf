/*
* Set local variables
*/ 
locals {
  public_nets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  cidr = "10.0.0.0/16"
  ami_name = "al2023-ami-2023.0.20230517.1-kernel-6.1-x86_64"
  instance_type = "t2.micro"
  project = "project-a"
  db_user = "db_user"
  db_password = "123456789"
}

/*
* Get the available zones
*/
data "aws_availability_zones" "available" {
  state = "available"
}

/*
* Select the ami
*/
data "aws_ami" "amazon-linux" {
  most_recent = true
  # owners      = [137112412989]

  filter {
    name   = "name"
    values = [local.ami_name]
  }
}

/*
* Create VPC
*/
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name = "${local.project}-vpc"
  cidr = local.cidr
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = local.public_nets
  enable_dns_hostnames = true
  enable_dns_support   = true
}


/*
* Create a launch template
*/
resource "aws_launch_configuration" "terramino" {
  name_prefix     = "${local.project}-template"
  image_id        = data.aws_ami.amazon-linux.id
  instance_type   = local.instance_type
  user_data       = file("install_httpd.sh")
  security_groups = [aws_security_group.terramino_instance.id]

  lifecycle {
    create_before_destroy = true
  }
}

/*
* Create auto scaling group
*/
resource "aws_autoscaling_group" "terramino" {
  name                 = "${local.project}-asg"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.terramino.name
  vpc_zone_identifier  = module.vpc.public_subnets

  tag {
    key                 = "Name"
    value               = "${local.project}-asg"
    propagate_at_launch = true
  }
}

/*
* Create load balancer
*/
resource "aws_lb" "terramino" {
  name               = "${local.project}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terramino_lb.id]
  subnets            = module.vpc.public_subnets
}

/*
* Create load balance listener
*/
resource "aws_lb_listener" "terramino" {
  load_balancer_arn = aws_lb.terramino.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terramino.arn
  }
}

/*
* Create target group for load balancer
*/
resource "aws_lb_target_group" "terramino" {
  name     = "${local.project}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  slow_start = 30
}


resource "aws_autoscaling_attachment" "terramino" {
  autoscaling_group_name = aws_autoscaling_group.terramino.id
  lb_target_group_arn    = aws_lb_target_group.terramino.arn
}

/*
* Create security groups for load balancer
*/
resource "aws_security_group" "terramino_instance" {
  name = "${local.project}-instance-sg"
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.terramino_lb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.terramino_lb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${local.project}-instance-sg"
  }
}

resource "aws_security_group" "terramino_lb" {
  name = "${local.project}-lb-sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${local.project}-lb-sg"
  }
}

/*
* Create RDS
*/
# resource "aws_db_instance" "terramino_db" {
#   identifier_prefix      = "${local.project}-rds-"
#   instance_class         = "db.t3.micro"
#   allocated_storage      = 5
#   engine                 = "postgres"
#   username               = local.db_user
#   password               = local.db_password
#   db_subnet_group_name   = aws_db_subnet_group.terramino_db_net.name
#   vpc_security_group_ids = [aws_security_group.rds.id]
#   parameter_group_name   = aws_db_parameter_group.terramino.name
#   publicly_accessible    = true
#   skip_final_snapshot    = true

#   tags = {
#     Name = "${local.project}-rds"
#   }
# }

# resource "aws_db_parameter_group" "terramino" {
#   name   = "terramino"
#   family = "postgres14"

#   parameter {
#     name  = "log_connections"
#     value = "1"
#   }
# }


# resource "aws_db_subnet_group" "terramino_db_net" {
#   name = "${local.project}-db-sg"
#   subnet_ids = module.vpc.public_subnets

#   tags = {
#     Name = "${local.project}-db-sg"
#   }
# }


# resource "aws_security_group" "rds" {
#   name = "${local.project}-rds-sg"
#   vpc_id = module.vpc.vpc_id

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "${local.project}-rds-sg"
#   }
# }
