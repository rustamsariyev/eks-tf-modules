# Customized: https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/modules/iam-assumable-role-with-oidc/variables.tf
variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = false
}

variable "serviceaccount" {
  description = "Service name usually reflected pod name and included to IAM Role name"
  type        = string
  default     = ""
}

variable "namespace" {
  description = "EKS cluster namespace"
  type        = string
  default     = ""
}

variable "iam_policy_json" {
  description = "IAM policy for service/pod, json formatted"
  type        = string
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = ""
}


variable "tags" {
  description = "A map of tags to add to IAM role resources"
  type        = map(string)
  default     = {}
}

