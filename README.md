# GitOps-Driven CI/CD Pipeline for AWS EKS

This repository contains a complete GitOps-driven CI/CD pipeline for deploying a sample Nginx microservice to an AWS EKS cluster.

## Overview

This project demonstrates a modern DevOps approach using GitOps principles for deploying containerized applications to Kubernetes. The pipeline automatically deploys and manages applications with a variety of tools and services.

## Key Features

- **Infrastructure as Code:** All AWS resources are provisioned using Terraform.
- **GitOps Workflow:** ArgoCD monitors the Git repository for changes and automatically applies them.
- **Continuous Deployment:** GitHub Actions workflows automate testing and deployment preparation.
- **Automated Rollbacks:** A custom rollback controller monitors deployments and handles automatic rollbacks.
- **Observability:** Prometheus and Grafana provide monitoring and alerting.
- **Containerization:** Applications are packaged in Docker containers.

## Architecture Components

- **AWS EKS:** Managed Kubernetes cluster.
- **Terraform:** Infrastructure as Code for AWS resources.
- **ArgoCD:** GitOps controller monitoring the Git repository.
- **Helm:** Package manager for Kubernetes applications.
- **GitHub Actions:** CI/CD workflow automation.
- **Prometheus & Grafana:** Monitoring and observability.
- **Custom Rollback Controller:** Automated rollback on deployment failure.

## Deployment Pipeline

The CI/CD pipeline includes the following stages:

1. **Infrastructure Provisioning:** Terraform creates the AWS EKS cluster and all required AWS resources.
2. **GitOps Setup:** ArgoCD monitors the Git repository and applies changes automatically.
3. **Application Deployment:** The Nginx microservice is deployed via Helm charts.
4. **Automated Rollbacks:** A custom controller monitors and rolls back failed deployments.

---

## Getting Started

### Prerequisites

- AWS Account
- GitHub repository
- Terraform installed
- `kubectl` installed
- Helm installed

### Setup Instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/gitops-eks-demo.git
   cd gitops-eks-demo
   ```

2. Configure AWS credentials:
   ```bash
   aws configure
   ```

3. Provision the EKS cluster with Terraform:
   ```bash
   chmod +x setup.sh
   ./setup.sh
   ```

   The setup script will:
   - Initialize and apply Terraform configurations.
   - Configure `kubectl` to connect to the EKS cluster.
   - Install ArgoCD, Prometheus, and other required components.
   - Set up namespaces and initial configurations.

4. Configure your GitHub repository:
   - Create a new GitHub repository.
   - Push this code to your GitHub repository.
   - Configure GitHub Actions secrets:
     - `AWS_ROLE_TO_ASSUME`: IAM role ARN with EKS access.

5. Access the ArgoCD UI:
   - Get the ArgoCD server URL and password from the setup script output.
   - Log in to the ArgoCD UI and verify the Nginx application is synced.

---

## GitOps Workflow

### Development

1. Make changes to the Helm chart in the `helm/nginx` directory.
2. Push changes to a feature branch.
3. Create a Pull Request.

### Continuous Integration

1. GitHub Actions runs linting and testing on the Helm chart.
2. Validates the configuration.

### Deployment

1. Merging to `develop` deploys to the staging environment.
2. Merging to `main` deploys to the production environment.
3. ArgoCD automatically detects changes and synchronizes the application.

### Monitoring & Rollbacks

- Prometheus monitors the application's health metrics.
- A custom rollback controller automatically rolls back failed deployments.
- ArgoCD ensures the desired state is maintained.

---

## Testing Rollback Mechanism

To test the automated rollback mechanism:

1. Make a breaking change to the application:
   ```bash
   # Update the Helm chart with an invalid configuration
   cd helm/nginx
   # Edit values.yaml - set an invalid image tag or introduce a configuration error
   git add .
   git commit -m "Introduce breaking change for testing rollback"
   git push
   ```

2. Observe the rollback process:
   - ArgoCD detects the changes and attempts to deploy.
   - Deployments fail to reach a ready state.
   - The custom rollback controller detects failure and triggers a rollback.
   - ArgoCD syncs back to the last known good state.

3. Check logs and events:
   ```bash
   kubectl get events -n dev
   kubectl logs -n argocd deployments/rollback-controller
   ```

---

## Cleanup

To clean up all resources:
```bash
terraform destroy
```

---

## Project Structure

- `terraform/`: Terraform configurations for AWS infrastructure.
- `helm/nginx/`: Helm chart for the Nginx application.
- `.github/workflows/`: GitHub Actions workflow definitions.
- `argocd-*.yaml`: ArgoCD configuration files.
- `rollback-controller.yaml`: Custom rollback controller configuration.
