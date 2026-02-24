resource "google_service_account" "vm_sa" {
  account_id   = "${var.prefix_name}-vm-sa"
  display_name = "Custom SA for VM Instance ${var.prefix_name}"
}


data "google_compute_image" "debian_image" {
  family  = "debian-12"
  project = "debian-cloud"
}


resource "tls_private_key" "ssh_key_pair" {
  algorithm = "ED25519"
}



resource "google_compute_instance" "vm" {
  name         = "${var.prefix_name}-vm"
  machine_type = "e2-micro"
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    enable-oslogin = "false"
    ssh-keys = "${var.vm_username}:${tls_private_key.ssh_key_pair.public_key_openssh}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
}