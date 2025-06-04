terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket01062025"
    key            = "project-name/terraform.tfstate"
    region         = "ap-south-1"
    #dynamodb_table = "terraform-locks"
  }
}
