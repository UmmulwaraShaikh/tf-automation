data "aws_ami" "server_ami" {
  most_recent = true
  owners = ["amazon"]
  filter {
      name = "owner-alias"
      values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_instance" "terraform_test_ec2" {
  count = var.instance_count
  ami = data.aws_ami.server_ami.id
 instance_type = var.instance_type
 key_name = var.instance_key_name

tags = {
 Name = "${var.cloud_env}_terraform_test_ec2"
}
 user_data = <<-EOF
 #!/bin/bash
 yum update -y
 yum install httpd -y
 EOF

vpc_security_group_ids = [aws_security_group.terraform_test_sg.id]
subnet_id = aws_subnet.public_subnet[0].id
root_block_device {
  volume_size = var.vol_size
}

//IAM

 iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

}

