# code piece commented out due to a weird libcrypto error that I do not have the wil to dig into. 

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

# security group allows ssh and web server connections. the Cidr block value implies any ip address can possibly make a ssh connection which is not a best practice.
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

# creates 3 ec2 instances; value definition such as ubuntu ami, keypair are supplied from the variable files. 
resource aws_instance "terra_ec2" {
    ami = lookup(var.terra_var, "ami")
    instance_type = lookup(var.terra_var, "ttype")
    key_name = lookup(var.access_key, "terra_access")
    security_groups = [aws_security_group.terra_sec.id]
    subnet_id = aws_subnet.terra-subnet[0].id

    count = 3

    tags = {
    Name = "altschool_project-${count.index}"
    Os = "ubuntu"
  }
} 

# outputs the ip addresses of the created ec2 instances.
output "terra_ec2_ip" {
    description = "Public IP addresses of ec2 instances"
    value = "${aws_instance.terra_ec2.*.public_ip}"
}
