resource "google_compute_disk" "disk" {
  ### META ARGUMENTS ###
  for_each = var.block_disks
  ######################

  name  = "${each.key}"
  type  = each.value.type
  zone  = "${var.gcp_region}-a"
  size = each.value.size_GB 
}