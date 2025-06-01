# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

# VPC Configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}

# EKS Cluster Configuration
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster and node group"
  type        = string
  default     = "1.29"
}

# ECR Repository
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

# Node Group Configuration
variable "desired_size" {
  description = "Desired number of worker nodes in the node group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of worker nodes in the node group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of worker nodes in the node group"
  type        = number
  default     = 3
}

variable "instance_types" {
  description = "List of EC2 instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Capacity type: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "ami_type" {
  description = "AMI type to use for the node group"
  type        = string
  default     = "AL2_x86_64"
}

variable "create_iam_role" {
  description = "Whether to create a new IAM role for the node group"
  type        = bool
  default     = true
}

variable "iam_role_name" {
  description = "Name of the IAM role to create for the node group"
  type        = string
  default     = "eks-flask-node-group-role"
}

variable "cluster_service_cidr" {
  description = "CIDR range for Kubernetes service IPs"
  type        = string
}
