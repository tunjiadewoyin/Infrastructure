variable "enable_logging" {
    description = "Enable logging for the EKS cluster."
    type        = bool
    default     = true
}

variable "kubernetes_version" {
    description = "The Kubernetes version for the EKS cluster."
    type        = string
    default     = "1.24"
}

variable "ami_id" {
    description = "The AMI ID for the worker nodes."
    type        = string
    default     = ""
}
