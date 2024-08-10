output "iam" {
  description = "The IAM members and their roles grouped by id. This output contains information such as the email, project ID, project number, the roles assigned to the member, related IAM resource details like etag and condition, and the project details."
  value = {
    iam = {
      for id in distinct([for info in local.combined_iam_info : info.id]) :
      id => {
        id             = id
        email          = lookup([for info in local.combined_iam_info : info if info.id == id][0], "email", null)
        member         = lookup([for info in local.combined_iam_info : info if info.id == id][0], "member", null)
        project_id     = lookup([for info in local.combined_iam_info : info if info.id == id][0], "project_id", null)
        project_number = lookup([for info in local.combined_iam_info : info if info.id == id][0], "project_number", null)
        resource = [for info in local.combined_iam_info : {
          member    = google_project_iam_member.iam_members["${info.member}-${info.role}"].member
          project   = google_project_iam_member.iam_members["${info.member}-${info.role}"].project
          etag      = google_project_iam_member.iam_members["${info.member}-${info.role}"].etag
          condition = google_project_iam_member.iam_members["${info.member}-${info.role}"].condition
        } if info.id == id][0]
        roles = [
          for info in local.combined_iam_info : info.role
          if info.id == id
        ]
      }
    }
    project = var.project
  }
}

output "project" {
  description = "The project details including project ID and project number."
  value       = var.project
}