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
    project_id     = "your-project-id"
    project_number = "your-project-number"
  }

  iam_members = [
    {
      id     = "user1"
      member = "user:user1@example.com"
      roles  = ["roles/logging.logWriter", "roles/bigquery.admin", "roles/viewer", ]
    },
    {
      id     = "user2"
      member = "user:user2@example.com"
      roles  = ["roles/logging.logWriter", "roles/bigquery.admin", "roles/viewer"]
    }
  ]
}

output "iam" {
  description = "The IAM members and their roles"
  value       = module.project_iam.iam
}
