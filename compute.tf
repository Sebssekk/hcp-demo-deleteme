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


# data "google_storage_bucket_object" "vm_conf" {
#   name   = "vm.conf"
#   bucket = "vm-conf-12345678"
# }


resource "google_compute_instance" "vm" {
  ### META ARGUMENTS ###
  lifecycle {
    #prevent_destroy = true
    #ignore_changes = [ labels ]
    # precondition {
    #   condition = data.google_storage_bucket_object.vm_conf.content_type == "text/plain"
    #   error_message = "WRONG CONTENT TYPE"
    # }
  }
  ######################
  name         = "${var.prefix_name}-vm"
  machine_type = var.vm_size
  zone         = "${var.gcp_region}-a"
  labels = {
    test = "aaa"
  }
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  # attached_disk {
  #   source = google_compute_disk.disk["disk1"].self_link
  # }
  dynamic "attached_disk" {
    for_each = local.block_disks
    iterator = disk
    content {
      source = google_compute_disk.disk[disk.key].self_link
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
   
  # metadata_startup_script = <<-EOT
  #   #!/bin/bash
  #   sudo apt-get update
  #   sudo apt-get install -y nginx
  #   sudo systemctl start nginx
  #   sudo systemctl enable nginx 
  #   cat <<EOF > /etc/nginx/conf.d/upstream.conf
  #   upstream backends {
  #   %{ for ip in google_compute_instance.vm2[*].network_interface[0].network_ip }
  #     server ${ip}:80
  #   %{endfor}
  #   }
  #   EOT

  connection {
    type = "ssh"
    user = var.vm_username
    host = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
    private_key = tls_private_key.ssh_key_pair.private_key_openssh
  }
  provisioner "remote-exec" {
    inline = [ "sudo apt-get update",              
               "sudo apt-get install -y nginx",
               "sudo systemctl start nginx",               
               "sudo systemctl enable nginx",]
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vm_sa.email
    scopes = ["cloud-platform"]
  }
}