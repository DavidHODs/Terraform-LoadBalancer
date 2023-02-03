variable "terra_var" {
    type = map(string)
    default = {
    ami = "ami-00874d747dde814fa"
    ttype = "t2.micro"
    terraapp = "terra-app"
    lb = "terra-lb"
    route_table = "0.0.0.0/0"
  }
}

variable "terra_zone" {
    type = map(list(string))
    default = {
        "zones" = ["us-east-1a", "us-east-1b"]
        "cidr" = ["10.0.1.0/24", "10.0.2.0/24"]
    }
}