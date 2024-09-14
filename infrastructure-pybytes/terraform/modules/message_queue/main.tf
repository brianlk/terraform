resource "aws_instance" "this" {
  ami           = "ami-050254a066001bc04" # Bitnami RabbitMQ
  instance_type = var.aws_ec2_instance_type

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  key_name = var.aws_key_pair_deployer

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 8
  }

  tags = {
    Name = "${var.tenant}-${var.environment}-message-queue"
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo rabbitmqctl add_user pybytes p@ssw0rd
    sudo rabbitmqctl set_user_tags pybytes administrator
    sudo rabbitmqctl set_permissions -p / pybytes ".*" ".*" ".*"

    echo "RabbitMQ setup complete"
  EOF
}
