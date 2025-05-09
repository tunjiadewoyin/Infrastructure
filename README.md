# Infrastructure Repository
This repository contains a complete implementation of a GitOps-driven CI/CD pipeline to deploy microservices to AWS EKS.

## Overview
This project demonstrates a modern DevOps approach using GitOps principles for deploying containerized applications to Kubernetes. The pipeline automatically deploys and manages applications with flexibility and scalability.

## Key Features

- **Infrastructure as Code**: AWS resources provisioned with Terraform.
- **GitOps Workflow**: Changes to the Git repository trigger automated deployments.
- **Containerization**: Applications are packaged in Docker containers.
- **CI/CD Automation**: GitHub Actions for continuous integration.
- **Kubernetes Deployment**: Helm charts with health checks and autoscaling.
- **Automatic Rollback**: Failed deployments automatically roll back to the last stable version.

## Deployment Instructions

### 1. Setup AWS Credentials
aws configure


### 2. Clone the Repository
git clone https://github.com/yourusername/gitops-demo.git
cd gitops-demo


### 3. Deploy the Infrastructure
cd infrastructure/terraform
terraform init
terraform apply


### 4. Configure `kubectl`
aws eks update-kubeconfig --region us-west-2 --name gitops-demo


### 5. Deploy ArgoCD
cd ../../k8s-setup
./install-argocd.sh


### 6. Deploy Application
kubectl apply -f gitops/argocd/applications/application.yaml


Alternatively, use the automated deployment script:
./deploy.sh

## Testing Rollback Mechanism

To test the rollback mechanism:

1. Deploy a working version of the application.
2. Update the application with a broken version.
3. Observe ArgoCD detecting the failed health checks.
4. Verify the automatic rollback to the previous working version.

# Run the rollback test script
./test-rollback.sh


## Accessing the Application

After deployment:

### Get the Application URL:
kubectl get svc -n sample-app sample-microservice -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"


Access the application in your browser or via `curl`:
curl http://<APPLICATION_URL>


### Accessing the ArgoCD UI

1. Get the ArgoCD password:
        kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    

2. Get the ArgoCD server URL:
        kubectl get svc argocd-server -n argocd -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
    

3. Access the ArgoCD UI in your browser:
        https://<ARGOCD_SERVER_URL>
    

    - **Username**: admin  
    - **Password**: `<ARGOCD_PASSWORD>`

## CI/CD Process

### Code Changes:
1. Developers make changes to the application code.
2. Changes are committed to the Git repository.

### CI Pipeline:
1. GitHub Actions builds the Docker image.
2. Runs tests on the application.
3. Pushes the image to Amazon ECR.
4. Updates the deployment manifest with the new image tag.

### CD Pipeline:
1. ArgoCD detects changes in the Git repository.
2. Synchronizes the cluster state with the desired state.
3. Deploys the application with the new image.
4. Monitors health checks and deployment status.

### Rollback Mechanism:
1. If the deployment fails health checks.
2. ArgoCD automatically reverts to the last working version.

## Cleanup

To remove all resources:
cd infrastructure/terraform
terraform destroy
