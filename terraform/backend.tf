terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket01062025 "          # 🔁 Replace with your actual bucket name
    key    = "terraform.tfstate"      # 🔁 A unique path/key in the bucket
    region = "ap-south-1"                         # 🔁 Your AWS region
    encrypt = true
  }
}
