# Configure GCP provider
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Create a VPC network (if not using default)
resource "google_compute_network" "vpc_network" {
  name                    = "web-app-vpc"
  auto_create_subnetworks = true
}

# Allow HTTP/SSH traffic
resource "google_compute_firewall" "web_firewall" {
  name    = "allow-http-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a Compute Engine instance
resource "google_compute_instance" "web_server" {
  name         = "web-server"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.gcp_image
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {} # Assigns a public IP
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
  EOF

  tags = ["http-server"]
}

# Create a Cloud Storage bucket
resource "google_storage_bucket" "static_assets" {
  name          = "${var.gcp_bucket_name}-${random_id.bucket_suffix.hex}"
  location      = var.gcp_region
  force_destroy = true # Allows bucket deletion even if not empty

  uniform_bucket_level_access = true # Recommended for security
}

# Generate random suffix for bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
