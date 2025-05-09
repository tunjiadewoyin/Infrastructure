#!/bin/bash
# setup.sh - Set up EKS infrastructure and configure kubectl

set -e

echo "Initializing Terraform..."
terraform init

echo "Validating Terraform configuration..."
terraform validate

echo "Planning Terraform changes..."
terraform plan -out=tfplan

echo "Applying Terraform changes to create EKS cluster..."
terraform apply tfplan

echo "Configuring kubectl to connect to the EKS cluster..."
aws eks update-kubeconfig --region $(terraform output -raw region) --name $(terraform output -raw cluster_name)

echo "Installing Helm on the local machine..."
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

echo "Installing ArgoCD with Helm..."
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
helm install argocd argo/argo-cd --namespace argocd --version 5.46.0 \
  --set server.service.type=LoadBalancer \
  --set server.extraArgs[0]="--insecure" \
  --set controller.resources.limits.cpu=1000m \
  --set controller.resources.limits.memory=2Gi \
  --set repoServer.resources.limits.cpu=1000m \
  --set repoServer.resources.limits.memory=2Gi \
  --set server.resources.limits.cpu=1000m \
  --set server.resources.limits.memory=2Gi

echo "Installing Prometheus and Grafana with Helm for monitoring..."
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.adminPassword=admin \
  --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false \
  --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false

echo "Installing AWS Load Balancer Controller..."
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=$(terraform output -raw cluster_name) \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller

echo "Creating namespaces for our application..."
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod

echo "Setup complete! Here's your ArgoCD UI URL:"
kubectl get svc argocd-server -n argocd -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
echo ""
echo "Initial ArgoCD admin password (change this after logging in):"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
echo ""