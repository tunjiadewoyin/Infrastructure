variable "role_name" {
    description = "The name of the IAM role."
    type        = string
}

variable "assume_role_policy" {
    description = "The policy that grants an entity permission to assume the role."
    type        = string
}

variable "permissions_boundary" {
    description = "The ARN of the policy that is used to set the permissions boundary for the role."
    type        = string
    default     = null
}

variable "tags" {
    description = "A map of tags to assign to the IAM role."
    type        = map(string)
    default     = {}
}