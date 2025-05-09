variable "ecr_repository_name" {
    description = "The name of the ECR repository."
    type        = string
}

variable "image_tag_mutability" {
    description = "The tag mutability setting for the ECR repository. Valid values are MUTABLE or IMMUTABLE."
    type        = string
    default     = "MUTABLE"
}

variable "image_scanning_configuration" {
    description = "Configuration block for image scanning settings."
    type        = object({
        scan_on_push = bool
    })
    default = {
        scan_on_push = true
    }
}

variable "lifecycle_policy" {
    description = "The JSON-formatted lifecycle policy for the ECR repository."
    type        = string
    default     = ""
}

variable "tags" {
    description = "A map of tags to assign to the resource."
    type        = map(string)
    default     = {}
}