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


module "project_iam" {
  source = "./.."

  project = {
    project_id     = "dui-module-test-18e5"
    project_number = "187203232446"
  }

  iam_members = [
    {
      id = "owner"
      member = "user:jasper@duizendstra.com"
      roles  = ["roles/logging.logWriter", "roles/bigquery.admin", "roles/viewer", ]
    },
    {
      id = "xxx"
      member = "user:duizendstra@gmail.com"
      roles  = ["roles/logging.logWriter", "roles/bigquery.admin", "roles/viewer"]
    }
  ]

  # iam_service_accounts = {
  #   "google-scan" = {
  #     roles = ["roles/logging.logWriter", "roles/bigquery.admin", "roles/viewer"]
  #   }
  # }

  # iam_service_agents = {
  #   "google-scan-agent" = {
  #     service = "dataform"
  #     roles   = ["roles/logging.logWriter", "roles/bigquery.admin", "roles/viewer"]
  #   }
  # }
}

output "iam" {
  description = "The IAM members and their roles"
  value       = module.project_iam.iam
}

# module "project_iam" {
#   source = "./.."

#   project = {
#     project_id     = "your-project-id"
#     project_number = "your-project-number"
#   }

#   accounts = {
#     "user1@example.com" = {
#       principal_type = "user"
#       roles          = ["roles/logging.logWriter", "roles/bigquery.admin"]
#     }
#     "user2@example.com" = {
#       principal_type = "user"
#       roles          = ["roles/viewer"]
#     }
#     "group@example.com" = {
#       principal_type = "group"
#       roles          = ["roles/editor"]
#     }
#     "service-account" = {
#       principal_type            = "serviceAccount"
#       roles                     = ["roles/logging.logWriter", "roles/logging.logReader"]
#       project_id                = "example-project-id"
#       is_google_service_account = false
#     }
#     "service-agent" = {
#       principal_type            = "serviceAgent"
#       roles                     = ["roles/container.admin"]
#       project_number            = "123456789012"
#       service                   = "containerregistry"
#       is_google_service_account = true
#     }
#   }
# }
