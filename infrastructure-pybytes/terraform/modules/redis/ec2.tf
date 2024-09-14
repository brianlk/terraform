data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "this" {
  subnet_id       = var.aws_vpc_subnet_id
  security_groups = var.aws_vpc_iface_security_groups
  lifecycle {
    ignore_changes = [attachment]
  }
}


resource "aws_instance" "this" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.aws_ec2_instance_type
  iam_instance_profile = var.aws_iam_instance_profile_name_pybytes_app
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
    Name = "${var.tenant}-${var.environment}-redis"
  }

  provisioner "remote-exec" {
    inline = ["echo EC2 instance is up and running"]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.aws_ec2_ssh_private_key)
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.aws_ec2_ssh_private_key} --extra-vars \"tenant=${var.tenant} env=${var.environment}\" ${path.module}/ansible/playbook.yml"
  }
}
