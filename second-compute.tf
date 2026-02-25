resource "google_service_account" "vm_sa2" {
  account_id   = "${var.prefix_name}-vm-sa2"
  display_name = "Custom SA for VM Instance ${var.prefix_name} 2"
}


resource "tls_private_key" "ssh_key_pair2" {
  algorithm = "ED25519"
}



resource "google_compute_instance" "vm2" {
  ### META ARGUMENTS ###
  depends_on = [ google_compute_instance.vm ]
  ######################

  name         = "${var.prefix_name}-vm2"
  machine_type = var.vm_size
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
    ssh-keys = "${var.vm_username}:${tls_private_key.ssh_key_pair2.public_key_openssh}"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vm_sa2.email
    scopes = ["cloud-platform"]
  }
}