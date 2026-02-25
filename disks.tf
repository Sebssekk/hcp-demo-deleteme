resource "google_compute_disk" "disk" {
  ### META ARGUMENTS ###
  for_each = var.block_disks
  ######################

  name  = "${each.key}"
  type  = each.value.type
  zone  = "${var.gcp_region}-a"
  physical_block_size_bytes = each.value.size_GB * 1024*1024
}