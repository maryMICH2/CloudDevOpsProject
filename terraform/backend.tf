terraform {
  backend "s3" {
    bucket = "ivolve-bucket-1891-6724-6439"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
