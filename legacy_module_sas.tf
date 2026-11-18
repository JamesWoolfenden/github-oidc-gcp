# One-shot adoption of the retired per-module CI identities.
#
# Each terraform-gcp-* module repo used to have its own SA + custom role +
# project binding (made with terraform-gcp-github-wif-sa, state since lost).
# All module repos now use the shared github-actions-terraform SA above, so
# these are dead. They are imported here only so the follow-up change can
# destroy them through IaC: delete this whole file in that change.
#
# ignore_changes = all keeps the import a pure no-op; the placeholder
# arguments below are never applied.

locals {
  legacy_module_repos = toset([
    "terraform-gcp-appengine",
    "terraform-gcp-artifact-reader",
    "terraform-gcp-artifact-repository",
    "terraform-gcp-bastion",
    "terraform-gcp-bigquery",
    "terraform-gcp-bigtable",
    "terraform-gcp-bigtable-backups",
    "terraform-gcp-cloud-armour",
    "terraform-gcp-cloudfunction",
    "terraform-gcp-cloudfunction2",
    "terraform-gcp-cloudrun",
    "terraform-gcp-cloudsource",
    "terraform-gcp-cloudsql",
    "terraform-gcp-cluster",
    "terraform-gcp-googlecomputeinstance",
    "terraform-gcp-helmrepo",
    "terraform-gcp-http-internal",
    "terraform-gcp-iam",
    "terraform-gcp-instance",
    "terraform-gcp-network",
    "terraform-gcp-redis",
    "terraform-gcp-secret-manager",
    "terraform-gcp-service",
    "terraform-gcp-statebucket",
    "terraform-gcp-staticip",
    "terraform-gcp-storage",
  ])
}

import {
  for_each = local.legacy_module_repos
  to       = google_service_account.legacy_module[each.key]
  id       = "projects/${var.project_id}/serviceAccounts/${substr(each.key, 0, 30)}@${var.project_id}.iam.gserviceaccount.com"
}

import {
  for_each = local.legacy_module_repos
  to       = google_project_iam_custom_role.legacy_module[each.key]
  id       = "projects/${var.project_id}/roles/${replace(each.key, "-", "_")}"
}

import {
  for_each = local.legacy_module_repos
  to       = google_project_iam_member.legacy_module[each.key]
  id       = "${var.project_id} projects/${var.project_id}/roles/${replace(each.key, "-", "_")} serviceAccount:${substr(each.key, 0, 30)}@${var.project_id}.iam.gserviceaccount.com"
}

resource "google_service_account" "legacy_module" {
  for_each   = local.legacy_module_repos
  account_id = substr(each.key, 0, 30)

  lifecycle {
    ignore_changes = all
  }
}

resource "google_project_iam_custom_role" "legacy_module" {
  for_each    = local.legacy_module_repos
  role_id     = replace(each.key, "-", "_")
  title       = each.key
  permissions = ["resourcemanager.projects.get"]

  lifecycle {
    ignore_changes = all
  }
}

resource "google_project_iam_member" "legacy_module" {
  for_each = local.legacy_module_repos
  project  = var.project_id
  role     = google_project_iam_custom_role.legacy_module[each.key].id
  member   = "serviceAccount:${google_service_account.legacy_module[each.key].email}"

  lifecycle {
    ignore_changes = all
  }
}
