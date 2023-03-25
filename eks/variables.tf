############ Common variables ###################
variable "create" {
  description = "Controls if EKS resources should be created (affects nearly all resources)"
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

############# Cluster ####################

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster (i.e.: `1.24`)"
  type        = string
  default     = null
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs where the nodes/node groups will be provisioned. If `control_plane_subnet_ids` is not provided, the EKS cluster control plane (ENIs) will be provisioned in these subnets"
  default     = []
}

variable "kms_key_enable_default_policy" {
  description = "Specifies whether to enable the default key policy. Defaults to `false`"
  type        = bool
  default     = null
}


############### EKS Managed Node Group ####################
variable "eks_managed_node_groups" {
  description = "Map of map of node groups to create. See `node_groups` module's documentation for more details"
  type        = any
  default     = {}
}

#################### aws-auth configmap #####################

variable "manage_aws_auth_configmap" {
  type        = bool
  description = "Determines whether to manage the aws-auth configmap"
  default     = null
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}