locals {
  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    ingress_9443_from_api = {
      description                   = "Node all egress"
      protocol                      = "-1"
      from_port                     = 9443
      to_port                       = 9443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  # This config stands for Terraform's official document
  # https://registry.terraform.io/providers/-/aws/4.52.0/docs/data-sources/iam_roles
  # For services like Amazon EKS that do not permit a path in the role ARN when used in a cluster's configuration map
  sso_role_arn       = [for parts in [for arn in data.aws_iam_roles.sso_admin.arns : split("/", arn)] : format("%s/%s", parts[0], element(parts, length(parts) - 1))]
  sso_role_arn_dev   = [for parts in [for arn in data.aws_iam_roles.sso_dev.arns : split("/", arn)] : format("%s/%s", parts[0], element(parts, length(parts) - 1))]

  aws_auth_roles = concat(
    [
      {
        rolearn  = element(local.sso_role_arn, 0)
        username = "administrator"
        groups   = ["system:masters"]
      }
    ],
    [
      {
        rolearn  = element(local.sso_role_arn_dev, 0)
        username = "developer"
        groups   = ["developers"]
      }
    ],
    var.aws_auth_roles

  )

  tags = merge(var.tags, {
    TfModuleName = "eks-tf-modules/eks"
  })
}
