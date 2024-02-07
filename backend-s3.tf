terraform {
  backend "s3" {
    bucket = "terraform-vproj"
    key    = "terraform-vproj/backend"
    region = "us-east-1"
  }
}