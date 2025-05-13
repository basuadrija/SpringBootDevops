variable "region" {
  type = string
  default = "ap-south-1"
}

variable "ssh" {

    type = number
    default = 22
  
}

variable "inbound" {

    type = number
    default = 8080
  
}

variable "ec2instance" {
    type = string
    default = "JenkinsServer"
  
}

variable "cidrephemeral" {
  
  type = string
  default = "0.0.0.0/0"
}

variable "cidrssh" {
  
  type = string
  default = "0.0.0.0/0"
}
