resource "tls_private_key" "terra_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terra_generated_key" {
  key_name   = lookup(var.terra_var, "keyname")
  public_key = tls_private_key.terra_private_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo ${tls_private_key.terra_private_key.private_key_pem} >> /home/david/aws/terra.pem && chmod a+x /home/david/aws/terra.pem"
  }
}

resource "aws_security_group" "terra_sec" {
    name = "terra_sec_group"
    vpc_id = aws_vpc.terra-vpc.id
    description = "Allow HTTP and SSH traffic via Terraform"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = lookup(var.my_ip, "ip")
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource aws_instance "terra_ec2" {
    ami = lookup(var.terra_var, "ami")
    instance_type = lookup(var.terra_var, "ttype")
    key_name = aws_key_pair.terra_generated_key.key_name 
    # ec2_associate_public_ip_address = true
    security_groups = [aws_security_group.terra_sec.id]
    subnet_id = aws_subnet.subnet[0].id

    count = 3

    tags = {
    Name = "altschool_project-${count.index}"
    Os = "ubuntu"
  }
} 
