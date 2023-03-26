module "irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.14.3"

  create_role                   = var.create_role
  role_name                     = "${var.serviceaccount}-pod-role-${var.env}"
  provider_url                  = replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.iam_policy[0].arn] # or AWS managed  "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.serviceaccount}"]
  tags                          = local.tags
}

resource "aws_iam_policy" "iam_policy" {
  count       = var.create_role ? 1 : 0
  name        = "${var.serviceaccount}-pod-policy-${var.env}"
  description = "IAM policy for IAM Role ${var.serviceaccount}-pod-role ${var.env}"
  policy      = var.iam_policy_json
  tags        = local.tags
}
