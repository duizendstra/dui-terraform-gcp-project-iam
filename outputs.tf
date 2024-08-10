output "iam" {
  description = "The IAM members and their roles grouped by id"
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

# Documentation of the "iam" Output:
#
# The `iam` output provides a map of IAM members and their roles, grouped by a unique `id`.
#
# Structure of the `iam` output:
# - `id`: The unique identifier for each IAM member.
# - `email`: The email associated with the IAM member.
# - `member`: The full IAM member string, which includes a prefix like `user:` or `serviceAccount:`.
# - `project_id`: The ID of the project to which the IAM roles are applied.
# - `project_number`: The project number associated with the member.
# - `resource`: A list of resources corresponding to the IAM roles, each containing:
#   - `member`: The IAM member string.
#   - `project`: The project ID where the IAM role is applied.
#   - `etag`: The etag for the IAM policy binding, used for optimistic concurrency control.
#   - `condition`: Any conditions associated with the IAM role, if present.
# - `roles`: A list of IAM roles assigned to the member.
#
# The `project` output returns the project object, containing:
# - `project_id`: The ID of the project.
# - `project_number`: The project number.
