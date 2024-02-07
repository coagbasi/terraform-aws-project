variable "AWS_REGION" {
  default = "us-west-1"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-1 = "ami-0c7217cdde317cfec"
    us-east-2 = "ami-06aa3f7caf3a30282"
    ap-south-1 = "ami-032346ab877c418af"

  }
}

variable "USERNAME" {
  default = "ubuntu"
}

variable "PUB_KEY" {
  default = "vprokey.pub"
}

variable "PRIV_KEY" {
  default = "vprokey"
}

variable "MYIP" {
    default = "192.168.1.145/32" 
}

variable "rmquser" {
    default = "rabbit"
}

variable "rmqpass" {
    default = "Gre12eetr312034fgl"
}

variable "dbname" {
    default = "accounts"
}

variable "dbuser" {
    default = "admin"
}

variable "dbpass" {
    default = "admin123"
}

variable "instance_count" {
    default = "1"
}

variable "VPC_NAME" {
    default = "vpro-vpc"
}

variable "Zone1" {
    default = "us-east-1a"
}

variable "Zone2" {
    default = "us-east-1b"
}

variable "Zone3" {
    default = "us-east-1c"
}

variable "VpcCIDR" {
    default = "172.21.0.0/16"
}

variable "PubSub1CIDR" {
    default = "172.21.1.0/24"
}

variable "PubSub2CIDR" {
    default = "172.21.2.0/24"
}

variable "PubSub3CIDR" {
    default = "172.21.3.0/24"
}

variable "PrivSub1CIDR" {
    default = "172.21.4.0/24"
}

variable "PrivSub2CIDR" {
    default = "172.21.5.0/24"
}

variable "PrivSub3CIDR" {
    default = "172.21.6.0/24"
}