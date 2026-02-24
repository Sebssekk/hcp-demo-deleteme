resource "google_compute_firewall" "public" {
  name    = "${var.prefix_name}-public-firewall"
  description = "Allow public traffic into my vm"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22","80","443"]
  }

  source_ranges = [ "0.0.0.0/0" ]
}