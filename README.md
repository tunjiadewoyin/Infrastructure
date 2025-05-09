GitOps-Driven CI/CD Pipeline for AWS EKS
This repository contains a complete GitOps-driven CI/CD pipeline for deploying a sample Nginx microservice to an AWS EKS cluster.
Architecture Overview
The architecture follows modern cloud-native GitOps principles:

Infrastructure as Code: All AWS resources are provisioned using Terraform
GitOps: ArgoCD monitors the Git repository for changes and automatically applies them
Continuous Deployment: GitHub Actions workflows automate testing and deployment preparation
Automated Rollbacks: Custom controller monitors deployments and handles automatic rollbacks
Observability: Prometheus and Grafana provide monitoring and alerting

Components

AWS EKS: Managed Kubernetes cluster
Terraform: Infrastructure as Code for AWS resources
ArgoCD: GitOps controller monitoring Git repository
Helm: Package manager for Kubernetes applications
GitHub Actions: CI/CD workflow automation
Prometheus & Grafana: Monitoring and observability
Custom Rollback Controller: Automated rollback on deployment failure

Deployment Pipeline
The CI/CD pipeline includes:

Infrastructure Provisioning: Terraform creates the EKS cluster and all required AWS resources
GitOps Setup: ArgoCD monitors the Git repository and applies changes automatically
Application Deployment: Nginx microservice deployed via Helm charts
Automated Rollbacks: Custom controller monitors and rolls back failed deployments

Getting Started
Prerequisites

AWS Account
GitHub repository
Terraform installed
kubectl installed
Helm installed

Setup Instructions

Clone this repository:
bashgit clone https://github.com/yourusername/gitops-eks-demo.git
cd gitops-eks-demo

Configure AWS credentials:
bashaws configure

Provision the EKS cluster with Terraform:
bashchmod +x setup.sh
./setup.sh

The setup script will:

Initialize and apply Terraform configurations
Configure kubectl to connect to the EKS cluster
Install ArgoCD, Prometheus, and other required components
Set up the namespaces and initial configuration


Configure GitHub repository:

Create a new GitHub repository
Push this code to your GitHub repository
Configure GitHub Actions secrets:

AWS_ROLE_TO_ASSUME: IAM role ARN with EKS access




Access ArgoCD UI:

Get the ArgoCD server URL and password from the setup script output
Log in to the ArgoCD UI
Verify that the Nginx application is synced



GitOps Workflow

Development:

Make changes to the Helm chart in the helm/nginx directory
Push changes to a feature branch
Create a Pull Request


Continuous Integration:

GitHub Actions runs linting and testing on the Helm chart
Validates the configuration


Deployment:

Merging to develop deploys to the staging environment
Merging to main deploys to the prod environment
ArgoCD automatically detects changes and synchronizes the application


Monitoring & Rollbacks:

Prometheus monitors the application's health metrics
Custom rollback controller automatically rolls back failed deployments
ArgoCD ensures desired state is maintained



Test Scenario: Deployment Failure and Rollback
To test the automated rollback mechanism:

Make a breaking change to the application:
bash# Update the Helm chart with an invalid configuration
cd helm/nginx
# Edit values.yaml - set an invalid image tag or introduce a configuration error
git add .
git commit -m "Introduce breaking change for testing rollback"
git push

Observe the rollback process:

ArgoCD detects the changes and attempts to deploy
Deployments fail to reach ready state
Custom rollback controller detects failure and triggers rollback
ArgoCD syncs back to the last known good state


Check logs and events:
bashkubectl get events -n dev
kubectl logs -n argocd deployments/rollback-controller


Resource Cleanup
To clean up all resources:
bashterraform destroy
Project Structure

terraform/: Terraform configurations for AWS infrastructure
helm/nginx/: Helm chart for the Nginx application
.github/workflows/: GitHub Actions workflow definitions
argocd-*.yaml: ArgoCD configuration files
rollback-controller.yaml: Custom rollback controller configuration

Design Choices
1. ArgoCD for GitOps
ArgoCD was chosen for its robust GitOps capabilities, user-friendly UI, and integration with Kubernetes.
2. Automated Rollbacks
The custom rollback controller monitors deployments and automatically triggers rollbacks when:

Too many pods fail to become ready
Health metrics exceed thresholds
Critical errors are detected in the logs

This approach provides quick recovery from failed deployments without human intervention.
3. Helm for Application Packaging
Helm was selected for application deployment because:

It provides templating for Kubernetes manifests
Supports versioning and rollbacks
Can be used with GitOps controllers like ArgoCD
Makes application updates consistent and repeatable

4. Terraform for Infrastructure
Terraform provides:

Declarative infrastructure definition
State management
Integration with AWS
Ability to version control infrastructure changes
