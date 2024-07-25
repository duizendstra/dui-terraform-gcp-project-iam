terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.38.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.38.0"
    }
  }
}

locals {
  transformed_iam_bindings = {
    for role, members in var.iam_bindings : role => [
      for member_config in members : {
        member = (
          member_config.transform_member && member_config.member_type == "serviceAgent" ?
          "serviceAccount:service-${coalesce(member_config.project_number, var.project_number)}@gcp-sa-${member_config.member}.iam.gserviceaccount.com" :
          member_config.transform_member && member_config.member_type == "serviceAccount" ?
          "serviceAccount:${member_config.member}@${coalesce(member_config.project_id, var.project_id)}.iam.gserviceaccount.com" :
          "${member_config.member_type}:${member_config.member}"
        ),
        project_id = coalesce(member_config.project_id, var.project_id)
      }
    ]
  }
}

resource "google_project_iam_binding" "project_iam_bindings" {
  for_each = local.transformed_iam_bindings
  project  = each.value[0].project_id # Assume all members for a role have the same project_id
  role     = each.key
  members  = [for v in each.value : v.member]
}