variable "terra_var" {
    type = map(string)
    default = {
    vpc = "vpc-0884586ec29d0d8b3"
    ami = "ami-00874d747dde814fa"
    ttype = "t2.micro"
    keyname = "terrakey"
    subnet = "172.31.0.0/16"
    terrapem = "/home/david/aws/terra.pem"
    terrapp = "terra_app"
    lb = "terra_lb"
  }
}