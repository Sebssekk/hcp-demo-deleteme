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
    random = {
      source = "hashicorp/random"
      version = "3.8.1"
    }
  }
}
provider "google" {
  # Configuration options
  project = var.project_id
}

provider "google"{
  project = var.project_id2
  alias = "G2"
}

provider "tls" {
  # Configuration options
}
provider "random" {
  # Configuration options
}