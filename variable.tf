variable "terra_var" {
    type = map(string)
    default = {
    vpc = "vpc-0884586ec29d0d8b3"
    ami = "ami-00874d747dde814fa"
    ttype = "t2.micro"
    keyname = "terrakey"
    terrapem = "/home/david/aws/terra.pem"
    terraapp = "terra-app"
    lb = "terra-lb"
    # zones = "us-east-1a", "us-east-1b"
  }
}

variable "terra_zone" {
    type = map(list(string))
    default = {
        "zones" = ["us-east-1a", "us-east-1b"]
        "cidr" = ["172.31.0.0/24", "172.31.7.0/24"]
    }
}