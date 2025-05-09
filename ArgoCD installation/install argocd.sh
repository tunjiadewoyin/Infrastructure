#!/bin/bash
set -e

# Variables
NAMESPACE=${NAMESPACE:-argocd}
HELM_VERSION=${HELM_VERSION:-5.24.1}
INGRESS_HOST=${INGRESS_HOST:-argocd.example.com}
GIT_REPO_URL=${GIT_REPO_URL:-https://github.com/yourusername/gitops-demo.git}

# Create ArgoCD namespace
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Add ArgoCD Helm repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install ArgoCD using Helm
helm upgrade --install argocd argo/argo-cd \
    --namespace $NAMESPACE \
    --version $HELM_VERSION \
    --values - <<EOF
server:
    ingress:
        hosts:
            - $INGRESS_HOST
    config:
        repositories: |
            - type: git
                url: $GIT_REPO_URL
EOF
