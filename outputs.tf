output "iam" {
  description = "The IAM members and their roles grouped by id"
  value = {
    for id in distinct([for info in local.combined_iam_info : info.id]) : id => {
      email = [for info in local.combined_iam_info : info.email if info.id == id][0]
      roles = distinct([for info in local.combined_iam_info : info.role if info.id == id])
      project_id = local.combined_iam_info[0].project_id
      project_number = local.combined_iam_info[0].project_number
    }
  }
}