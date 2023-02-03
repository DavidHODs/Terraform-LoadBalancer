# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "terra_generated_key" {
#   key_name   = lookup(var.terra_var, "keyname")
#   public_key = tls_private_key.rsa.public_key_openssh

#   provisioner "local-exec" {
#     command = "echo ${tls_private_key.rsa.private_key_pem} >> /home/david/aws/terrakey.pem && chmod 600 /home/david/aws/terrakey.pem"
#   }
# }

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
        cidr_blocks = ["0.0.0.0/0"]
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
    key_name = lookup(var.access_key, "terra_access")
    # ec2_associate_public_ip_address = true
    security_groups = [aws_security_group.terra_sec.id]
    subnet_id = aws_subnet.terra-subnet[0].id

    count = 3

    tags = {
    Name = "altschool_project-${count.index}"
    Os = "ubuntu"
  }
} 
