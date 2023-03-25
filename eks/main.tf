provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# SSO AdministratorAccess PermissionSet: This role automaticaly created by AWS.
data "aws_iam_roles" "sso_admin" {
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
  name_regex  = "AWSReservedSSO_AdministratorAccess_.*"
}

data "aws_iam_roles" "sso_dev" {
  path_prefix = "/aws-reserved/sso.amazonaws.com/"
  name_regex  = "AWSReservedSSO_ReadOnlyAccess_.*"
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.1"

  create                                  = var.create
  tags                                    = local.tags
  cluster_name                            = var.cluster_name
  cluster_version                         = var.cluster_version
  cluster_endpoint_public_access          = var.cluster_endpoint_public_access
  vpc_id                                  = var.vpc_id
  subnet_ids                              = var.subnet_ids
  kms_key_enable_default_policy           = var.kms_key_enable_default_policy
  eks_managed_node_groups                 = var.eks_managed_node_groups
  manage_aws_auth_configmap               = var.manage_aws_auth_configmap
  aws_auth_users                          = var.aws_auth_users
  aws_auth_accounts                       = var.aws_auth_accounts
  aws_auth_roles                          = local.aws_auth_roles
  cluster_security_group_additional_rules = local.cluster_security_group_additional_rules
  node_security_group_additional_rules    = local.node_security_group_additional_rules

  cluster_addons = {
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  eks_managed_node_group_defaults = {
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
  }
}
