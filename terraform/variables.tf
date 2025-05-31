variable "aws_region" {}
variable "vpc_cidr" {}
variable "subnet_cidrs" {
  type = list(string)
}
variable "cluster_name" {}
variable "repository_name" {}
