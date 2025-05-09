This repository contains a complete implementation of a GitOps-driven CI/CD pipeline to deploy microservices to AWS EKS.
Overview
This project demonstrates a modern DevOps approach using GitOps principles for deploying containerized applications to Kubernetes. The pipeline automatically deploys and manages applications with fully automated rollbacks for failed deployments.
Key Features

Infrastructure as Code: AWS resources provisioned with Terraform
GitOps Workflow: Changes to Git repository trigger automated deployments
Containerization: Application packaged in Docker container
CI/CD Automation: GitHub Actions for continuous integration
Kubernetes Deployment: Helm charts with health checks and autoscaling
Automatic Rollback: Failed deployments automatically roll back to the last stable version

Deployment Instructions
Setup AWS Credentials
bashaws configure
Clone the Repository
bashgit clone https://github.com/yourusername/gitops-demo.git
cd gitops-demo
Deploy the Infrastructure
bashcd infrastructure/terraform
terraform init
terraform apply
Configure kubectl
bashaws eks update-kubeconfig --region us-west-2 --name gitops-demo
Deploy ArgoCD
bashcd ../../k8s-setup
./install-argocd.sh
Deploy Application
bashkubectl apply -f gitops/argocd/applications/application.yaml
Alternatively, Use Automated Deployment Script
bash./deploy.sh
Testing Rollback Mechanism
To test the rollback mechanism:

Deploy a working version of the application
Update the application with a broken version
Observe ArgoCD detecting the failed health checks
Verify the automatic rollback to the previous working version

bash# Run the rollback test script
./test-rollback.sh
Accessing the Application
After deployment:

Get the application URL:

bashkubectl get svc -n sample-app sample-microservice -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"

Access the application in your browser or via curl:

bashcurl http://<APPLICATION_URL>
Accessing ArgoCD UI
Get the ArgoCD password:
bashkubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
Get the ArgoCD server URL:
bashkubectl get svc argocd-server -n argocd -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
Access the ArgoCD UI in your browser:
https://<ARGOCD_SERVER_URL>
Username: admin
Password: <ARGOCD_PASSWORD>
CI/CD Process

Code Changes:

Developers make changes to the application code
Changes are committed to the Git repository


CI Pipeline:

GitHub Actions builds the Docker image
Runs tests on the application
Pushes the image to Amazon ECR
Updates the deployment manifest with the new image tag


CD Pipeline:

ArgoCD detects changes in the Git repository
Synchronizes the cluster state with the desired state
Deploys the application with the new image
Monitors health checks and deployment status


Rollback Mechanism:

If the deployment fails health checks
ArgoCD automatically reverts to the last working version



Cleanup
To remove all resources:
bashcd infrastructure/terraform
terraform destroy
Contributing
Contributions are welcome! Please feel free to submit a Pull Request.
License
This project is licensed under the MIT License - see the LICENSE file for details.
