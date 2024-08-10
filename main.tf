terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.40.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.40.0"
    }
  }
}

locals {
  project_id     = var.project.project_id
  project_number = var.project.project_number

  # Standardizing IAM members info
  standardized_iam_members = flatten([
    for config in var.iam_members : [
      for role in config.roles : {
        id             = config.id
        member         = config.member
        email          = split(":", config.member)[1]
        role           = role
        project_id     = null
        project_number = null
      }
    ]
  ])

  # Standardizing IAM service accounts info
  standardized_iam_service_accounts = flatten([
    for config in var.iam_service_accounts : [
      for role in config.roles : {
        id             = config.id
        member         = "serviceAccount:${config.id}@${coalesce(config.project_id, local.project_id)}.iam.gserviceaccount.com"
        email          = "${config.id}@${coalesce(config.project_id, local.project_id)}.iam.gserviceaccount.com"
        role           = role
        project_id     = coalesce(config.project_id, local.project_id)
        project_number = null
      }
    ]
  ])

  # Standardizing IAM service agents info
  standardized_iam_service_agents = flatten([
    for config in var.iam_service_agents : [
      for role in config.roles : {
        id             = config.id
        member         = "serviceAccount:service-${coalesce(config.project_number, local.project_number)}@gcp-sa-${config.service}.iam.gserviceaccount.com"
        email          = "service-${coalesce(config.project_number, local.project_number)}@gcp-sa-${config.service}.iam.gserviceaccount.com"
        role           = role
        project_id     = null
        project_number = coalesce(config.project_number, local.project_number)
      }
    ]
  ])

  combined_iam_info = concat(local.standardized_iam_members, local.standardized_iam_service_accounts, local.standardized_iam_service_agents)

  # Group by member and role
  grouped_iam_info = {
    for info in local.combined_iam_info :
    "${info.member}-${info.role}" => {
      id             = info.id
      member         = info.member
      email          = info.email
      role           = info.role
      project_id     = coalesce(info.project_id, local.project_id)
      project_number = coalesce(info.project_number, local.project_number)
    }
  }
}

resource "google_project_iam_member" "iam_members" {
  for_each = local.grouped_iam_info
  project  = each.value.project_id
  role     = each.value.role
  member   = each.value.member
}
