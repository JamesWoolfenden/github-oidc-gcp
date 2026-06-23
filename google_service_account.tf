resource "google_service_account" "github_actions" {
  account_id   = "github-actions-terraform"
  display_name = "GitHub Actions Terraform"
  description  = "Service account used by GitHub Actions via Workload Identity Federation"
}

resource "google_service_account_iam_binding" "github_wif" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository_owner/JamesWoolfenden",
  ]
}

resource "google_project_iam_member" "github_actions_viewer" {
  project = var.project_id
  role    = "roles/viewer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "read_only" {
  project = var.project_id
  role    = google_project_iam_custom_role.terraform_pike_plan.name
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}
