# eks-tf-modules
This module contains eks related terraform files

# Tagging module before push.
```
tag=v0.0.(number) 
git tag -a "$tag" -m "$(git log -1 --pretty=%B)" && git push origin "$tag"
```

# Configures kubectl so that you can connect to an Amazon EKS cluster.  SSO login with Admin role
```
aws eks update-kubeconfig --region eu-central-1 --name webapp-prod --alias webapp-prod-admin
```
# Deploy
```
kubectl apply -f deployment.yaml
kubectl apply -f developer_eks_access.yaml
```
# Configures kubectl so that you can connect to an Amazon EKS cluster. SSO login with developer role
```
aws eks update-kubeconfig --region eu-central-1 --name webapp-prod --alias webapp-prod-dev
```
# Test developer user permissions
```
kubectl get pods or kubectl auth can-i create pods
kubectl get deployments.apps  or  kubectl auth can-i create deployments
```
# Select developer namespace
```
kubectl get pods -n developer-ns  or  kubectl auth can-i create pods -n developer-ns
kubectl get deployments.apps -n developer-ns  or kubectl auth can-i create deployments -n developer-ns
```
# Check s3 access
```               pod_name
kubectl exec developer-deployment-55697b8dc6-lr5w9  -n developer-ns -- aws s3 ls
```