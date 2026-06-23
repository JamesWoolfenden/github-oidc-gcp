variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "pike-477416"

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west2"
  validation {
    condition     = length(trimspace(var.region)) > 0
    error_message = "region must not be empty."
  }
}
