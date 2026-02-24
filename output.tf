output "vm_public_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "vm_private_ip" {
  value = google_compute_instance.vm.network_interface[0].network_ip
}

output "ssh_private_key" {
  value = tls_private_key.ssh_key_pair.private_key_openssh
  sensitive = true
}