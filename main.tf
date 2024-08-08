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
  project = var.project.project_id

  # Standardizing IAM members info
  iam_members_info = flatten([
    for config in var.iam_members : [
      for role in config.roles : {
        id             = config.id
        email          = config.member
        role           = role
        project_id     = null
        project_number = null
      }
    ]
  ])

  # Standardizing IAM service accounts info
  iam_service_accounts_info = flatten([
    for config in var.iam_service_accounts : [
      for role in config.roles : {
        id             = config.id
        email          = "serviceAccount:${config.id}@${coalesce(config.project_id, var.project.project_id)}.iam.gserviceaccount.com"
        role           = role
        project_id     = coalesce(config.project_id, var.project.project_id)
        project_number = null
      }
    ]
  ])

  # Standardizing IAM service agents info
  iam_service_agents_info = flatten([
    for config in var.iam_service_agents : [
      for role in config.roles : {
        id             = config.id
        email          = "serviceAccount:service-${coalesce(config.project_number, var.project.project_number)}@gcp-sa-${config.service}.iam.gserviceaccount.com"
        role           = role
        project_id     = null
        project_number = coalesce(config.project_number, var.project.project_number)
      }
    ]
  ])

  combined_iam_info = concat(local.iam_members_info, local.iam_service_accounts_info, local.iam_service_agents_info)

  # Group by email and role
  grouped_iam_info = {
    for info in local.combined_iam_info :
    "${info.email}-${info.role}" => {
      id             = info.id
      email          = info.email
      role           = info.role
      project_id     = coalesce(info.project_id, var.project.project_id)
      project_number = coalesce(info.project_number, var.project.project_number)
    }
  }
}

resource "google_project_iam_member" "iam_members" {
  for_each = local.grouped_iam_info
  project  = each.value.project_id
  role     = each.value.role
  member   = each.value.email
}




