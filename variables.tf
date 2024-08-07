variable "project" {
  description = "The project configuration containing the project_id and project_number"
  type = object({
    project_id     = string
    project_number = string
  })
}

variable "accounts" {
  description = "A map of principals to their configuration"
  type = map(object({
    principal_type            = string
    roles                     = list(string)
    is_google_service_account = optional(bool, false) # Renamed for better clarity
    project_id                = optional(string)
    project_number            = optional(string)
    service                   = optional(string)
  }))
  default = {}
}