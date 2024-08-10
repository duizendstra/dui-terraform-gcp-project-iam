output "iam" {
  description = "The IAM members and their roles grouped by id"
  value = {
    iam_members = {
      for id in [for info in local.combined_iam_info : info.id] : id => {
        email          = [for info in local.combined_iam_info : info.email if info.id == id][0]
        roles          = [for info in local.combined_iam_info : info.role if info.id == id]
        project_id     = [for info in local.combined_iam_info : info.project_id if info.id == id][0]
        project_number = [for info in local.combined_iam_info : info.project_number if info.id == id][0]
      }
    }
  }
}
