# plan role
resource "google_project_iam_custom_role" "terraform_pike_plan" {
  project     = var.project_id
  role_id     = "terraform_pike_plan"
  title       = "terraform_pike_plan"
  description = "A user with least privileges"
  permissions = [
    "compute.firewalls.get",
    "compute.globalOperations.get",
    "compute.networks.get",
    "compute.routers.get",
    "compute.subnetworks.get",
    "resourcemanager.projects.get" //for google_project datasource
  ]
}