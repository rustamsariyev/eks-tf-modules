locals {
  tags = merge(var.tags, {
    TfModuleName = "eks-tf-modules/irsa"
  })
}
