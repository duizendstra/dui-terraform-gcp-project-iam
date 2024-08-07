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
  transformed_principal = {
    for principal, config in var.accounts : principal => [
      for role in config.roles : {
        role           = role,
        project_id     = coalesce(config.project_id, var.project.project_id),
        project_number = coalesce(config.project_number, var.project.project_number),
        account        = principal,
        type           = config.principal_type,
        transformed = (
          config.is_google_service_account && config.principal_type == "serviceAgent" ?
          "serviceAccount:service-${coalesce(config.project_number, var.project.project_number)}@gcp-sa-${config.service}.iam.gserviceaccount.com" :
          config.is_google_service_account && config.principal_type == "serviceAccount" ?
          "serviceAccount:${principal}@${coalesce(config.project_id, var.project.project_id)}.iam.gserviceaccount.com" :
          "${config.principal_type}:${principal}"
        ),
        email = config.is_google_service_account ? (
          config.principal_type == "serviceAgent" ?
          "service-${coalesce(config.project_number, var.project.project_number)}@gcp-sa-@${config.service}.iam.gserviceaccount.com" :
          "${principal}@${coalesce(config.project_id, var.project.project_id)}.iam.gserviceaccount.com"
        ) : "${config.principal_type}:${principal}"
      }
    ]
  }

  transformed_account_roles = flatten([
    for principal, role_configs in local.transformed_principal : [
      for role_config in role_configs : {
        role           = role_config.role,
        project_id     = role_config.project_id,
        project_number = role_config.project_number,
        account        = role_config.account,
        type           = role_config.type,
        email          = role_config.transformed
      }
    ]
  ])
}

resource "google_project_iam_member" "account_iam_members" {
  for_each = {
    for role_config in local.transformed_account_roles : "${role_config.account}-${role_config.role}" => role_config
  }
  project = each.value.project_id
  role    = each.value.role
  member  = each.value.email
}