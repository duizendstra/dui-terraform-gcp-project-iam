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

module "project_iam" {
  source         = "./.."
  project_id     = "your-project-id"
  project_number = "your-project-number"
  iam_bindings = {
    "roles/logging.logWriter" = [
      {
        member           = "user@example.com"
        member_type      = "user"
        transform_member = false
        project_id       = ""
        project_number   = ""
      }
    ]
    "roles/bigquery.admin" = [
      {
        member           = "dataform-sa"
        member_type      = "serviceAccount"
        transform_member = true
        project_id       = ""
        project_number   = ""
      },
      {
        member           = "run-sa"
        member_type      = "serviceAccount"
        transform_member = true
        project_id       = ""
        project_number   = ""
      }
    ]
    "roles/iam.serviceAccountTokenCreator" = [
      {
        member           = "dataform"
        member_type      = "serviceAgent"
        transform_member = true
        project_id       = ""
        project_number   = ""
      },
    ]
    "roles/artifactregistry.admin" = [
      {
        member           = "user@example.com"
        member_type      = "user"
        transform_member = false
        project_id       = ""
        project_number   = ""
      }
    ]
    "roles/workflows.invoker" = [
      {
        member           = "cloudscheduler-sa"
        member_type      = "serviceAccount"
        transform_member = true
        project_id       = ""
        project_number   = ""
      }
    ]
    "roles/bigquery.jobUser" = [
      {
        member           = "workflows-sa"
        member_type      = "serviceAccount"
        transform_member = true
        project_id       = ""
        project_number   = ""
      }
    ]
    "roles/bigquery.dataViewer" = [
      {
        member           = "workflows-sa"
        member_type      = "serviceAccount"
        transform_member = true
        project_id       = ""
        project_number   = ""
      }
    ]
    "roles/run.invoker" = [
      {
        member           = "workflows-sa"
        member_type      = "serviceAccount"
        transform_member = true
        project_id       = ""
        project_number   = ""
      }
    ]
    "roles/datastore.owner" = [
      {
        member           = "run-sa"
        member_type      = "serviceAccount"
        transform_member = true
        project_id       = ""
        project_number   = ""
      }
    ]
  }
}
