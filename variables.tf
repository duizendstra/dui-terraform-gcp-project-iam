variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "project_number" {
  description = "The number of the GCP project"
  type        = string
}

variable "iam_bindings" {
  description = "A map of roles to a list of members with their configurations"
  type = map(list(object({
    member           = string
    member_type      = string
    transform_member = bool
    project_id       = string
    project_number   = string
  })))
  default = {}
}