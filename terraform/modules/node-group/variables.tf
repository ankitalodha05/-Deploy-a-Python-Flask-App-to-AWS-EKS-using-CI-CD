variable "cluster_name" {}
variable "cluster_version" {}
variable "vpc_id" {}
variable "subnet_ids" {
  type = list(string)
}

variable "desired_size" {}
variable "min_size" {}
variable "max_size" {}

variable "instance_types" {
  type = list(string)
}
variable "capacity_type" {}
variable "ami_type" {}

variable "create_iam_role" {}
variable "iam_role_name" {}
variable "cluster_service_cidr" {}
