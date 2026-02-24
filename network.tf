resource "google_compute_network" "vpc_network" {
  name = "${var.prefix_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.prefix_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
}