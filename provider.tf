terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.20.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "qwiklabs-gcp-03-a55e0a83ba99"
}