resource "google_service_account" "vm_sa2" {
  count = var.second_instance_num > 0 ? 1 : 0
  account_id   = "${var.prefix_name}-vm-sa2"
  display_name = "Custom SA for VM Instance ${var.prefix_name} 2"
}

resource "tls_private_key" "ssh_key_pair2" {
  count = var.second_instance_num > 0 ? 1 : 0
  algorithm = "ED25519"
}

resource "google_compute_instance" "vm2" {
  ### META ARGUMENTS ###
  #depends_on = [ google_compute_instance.vm ]
  count = var.second_instance_num
  ######################

  name         = "${var.prefix_name}-vm2-${count.index}"
  machine_type = var.vm_size
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.id

    //access_config {
    //  // Ephemeral public IP
    //}
  }

  metadata = {
    enable-oslogin = "false"
    ssh-keys = "${var.vm_username}:${tls_private_key.ssh_key_pair2[0].public_key_openssh}"
  }

  metadata_startup_script = <<-EOT
      sudo apt-get update
      sudo apt-get install -y nginx
      sudo systemctl start nginx
      sudo systemctl enable nginx
      cat <<EOF | sudo tee /var/www/html/index.html
      ${local.html_content}
      EOF
      sudo chown www-data:www-data /var/www/html/index.htm
      EOT

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vm_sa2[0].email
    scopes = ["cloud-platform"]
  }
}

locals {
  html_content = file("${path.module}/index.html")
}

output "private_ip_vm2" {
  value = google_compute_instance.vm2[*].network_interface[0].network_ip
}