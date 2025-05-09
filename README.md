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