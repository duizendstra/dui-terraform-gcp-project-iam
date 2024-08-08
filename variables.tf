variable "project" {
  description = "The project object containing the project ID and project number."
  type = object({
    project_id     = string
    project_number = string
  })
  validation {
    condition     = length(var.project.project_id) >= 6 && length(var.project.project_id) <= 30 && can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project.project_id))
    error_message = "The project ID must be between 6 and 30 characters, including the suffix, and can only contain lowercase letters, digits, and hyphens. It must start with a letter and cannot end with a hyphen."
  }
}

variable "is_authoritative" {
  description = "Indicates whether the IAM policies should be authoritative. Defaults to true."
  type        = bool
  default     = true
}

variable "iam_members" {
  description = "A list of members and their IAM roles."
  type = list(object({
    id     = string
    member = string
    roles  = list(string)
  }))
  default = []

  validation {
    condition     = length(distinct([for config in var.iam_members : config.id])) == length(var.iam_members)
    error_message = "Each id in the iam_members list must be unique."
  }

  validation {
    condition     = length(distinct([for config in var.iam_members : config.member])) == length(var.iam_members)
    error_message = "Each member in the iam_members list must be unique."
  }

  validation {
    condition     = alltrue([for config in var.iam_members : length(distinct(config.roles)) == length(config.roles)])
    error_message = "Roles within each member's roles list must be unique."
  }
}

variable "iam_service_accounts" {
  description = "A list of service accounts and their IAM roles."
  type = list(object({
    id                          = string
    service_account_description = string
    roles                       = list(string)
    project_id                  = optional(string)
  }))
  default = []

  validation {
    condition     = length(distinct([for sa in var.iam_service_accounts : sa.id])) == length(var.iam_service_accounts)
    error_message = "Each service account ID in the iam_service_accounts list must be unique."
  }

  validation {
    condition     = length(distinct([for sa in var.iam_service_accounts : sa.service_account_description])) == length(var.iam_service_accounts)
    error_message = "Each service account description in the iam_service_accounts list must be unique."
  }

  validation {
    condition     = alltrue([for sa in var.iam_service_accounts : length(distinct(sa.roles)) == length(sa.roles)])
    error_message = "Roles within each service account's roles list must be unique."
  }
}

variable "iam_service_agents" {
  description = "A list of service agents and their IAM roles."
  type = list(object({
    id             = string
    service        = string
    roles          = list(string)
    project_number = optional(string)
  }))
  default = []

  validation {
    condition     = length(distinct([for sa in var.iam_service_agents : sa.id])) == length(var.iam_service_agents)
    error_message = "Each id in the iam_service_agents list must be unique."
  }

  validation {
    condition     = length(distinct([for sa in var.iam_service_agents : sa.service])) == length(var.iam_service_agents)
    error_message = "Each service in the iam_service_agents list must be unique."
  }

  validation {
    condition     = length(distinct([for sa in var.iam_service_agents : "${sa.id}-${sa.service}"])) == length(var.iam_service_agents)
    error_message = "Each combination of id and service in the iam_service_agents list must be unique."
  }

  validation {
    condition     = alltrue([for sa in var.iam_service_agents : length(distinct(sa.roles)) == length(sa.roles)])
    error_message = "Roles within each service agent's roles list must be unique."
  }
}

