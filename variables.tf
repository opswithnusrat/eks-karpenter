variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "karpenter-cluster"
  
}
variable "aws_region" {
  description = "The AWS region where the EKS cluster is deployed"
  type        = string
  default     = "us-east-1"
}