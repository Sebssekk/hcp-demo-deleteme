locals {
  block_disks = { for idx,size in var.extra_disks :
    "disk${idx + 1}" => {
      size_GB = size,
      type = var.extra_disks_type
    }
  }
  # block_disks = {
  #   disk1 = {
  #     size_GB = 20,
  #     type = "pd-ssd"
  #   }
  #   disk2 = {
  #     size_GB = 10,
  #     type = "pd-ssd"
  #   }
  #   disk3 = {
  #     size_GB = 5,
  #     type = "pd-ssd"
  #   }
  # }
}


resource "google_compute_disk" "disk" {
  ### META ARGUMENTS ###
  for_each = local.block_disks
  ######################

  name  = "${each.key}"
  type  = each.value.type
  zone  = "${var.gcp_region}-a"
  size = each.value.size_GB 
}