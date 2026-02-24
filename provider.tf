terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "4.2.1"
    }
    google = {
      source = "hashicorp/google"
      version = "7.20.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.project_id
}
provider "tls" {
  # Configuration options
}