variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region (e.g., us-central1)"
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone (e.g., us-central1-a)"
  default     = "us-central1-a"
}

variable "gcp_machine_type" {
  description = "Compute Engine machine type"
  default     = "e2-micro" # Free tier eligible
}

variable "gcp_image" {
  description = "Boot image for VM"
  default     = "debian-cloud/debian-11" # Debian 11
}

variable "gcp_bucket_name" {
  description = "Base name for Cloud Storage bucket"
  default     = "static-assets"
}
