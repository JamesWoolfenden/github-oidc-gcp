terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.37.0"
    }
  }
  required_version = ">= 1.5.0"

  backend "gcs" {
    bucket = "terraform-pike-bucket-tfstate"
    prefix = "github-oidc-gcp"
  }
}

# holden:ignore:HLD_GCP_059
provider "google" {
  project = var.project_id
  region  = var.region

  default_labels = {
    created_by = "terraform"
    module     = "github-oidv-gcp"
  }
}
