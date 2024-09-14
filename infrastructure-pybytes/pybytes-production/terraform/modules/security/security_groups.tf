resource "aws_security_group" "allow_https_from_internet" {
  name        = "allow_https"
  description = "Allow HTTPS inbound traffic"
  vpc_id      = var.aws_vpc_id

  ingress {
    description      = "TLS from 0"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_https"
  }
}

resource "aws_security_group" "allow_ssh_from_pycom" {
  name        = "allow_ssh_from_pycom_office"
  description = "Allow SSH from pycom office"
  vpc_id      = var.aws_vpc_id

  ingress {
    description = "SSH from pycom office"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["130.93.143.2/32", "37.17.217.45/32", "82.174.41.58/32", "88.170.119.18/32"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_internet_access" {
  name        = "allow_internet_access"
  description = "Allow Internet access"
  vpc_id      = var.aws_vpc_id

  egress {
    description = "Allow Internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_internet_access"
  }
}



resource "aws_security_group" "allow_mqtt_from_internet" {
  name        = "allow_mqtt_from_internet"
  description = "Allow MQTT from internet"
  vpc_id      = var.aws_vpc_id

  ingress {
    description = "Allow MQTT from internet"
    from_port   = 1883
    to_port     = 1883
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow MQTT from internet"
    from_port   = 8883
    to_port     = 8883
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow MQTT from internet"
    from_port   = 9883
    to_port     = 9883
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow MQTT from internet"
    from_port   = 3002
    to_port     = 3002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_mqtt"
  }
}

resource "aws_security_group" "allow_internal_traffic" {
  name        = "allow_internal_traffic"
  description = "Allow internal traffic between components"
  vpc_id      = var.aws_vpc_id

  dynamic "ingress" {
    for_each = var.aws_eb_internal_ports
    content {
      description = "allow ${ingress.value["name"]} traffic internally"
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = "tcp"
      cidr_blocks = [var.aws_vpc_subnet_cidr]
    }
  }

  tags = {
    Name = "allow_internal_traffic"
  }
}
