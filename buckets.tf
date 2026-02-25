resource "random_string" "bucket_suffix" {
  length           = 16
  special          = false
  lower = true
  upper = false
}

resource "google_storage_bucket" "bucket" {
  ### META ARGUMENTS ###
  for_each = var.bucket_prefix
  provider = google.G2
  lifecycle {
    ignore_changes = [ storage_class ]
  }
  ######################
  
  name          = "${each.value}-${random_string.bucket_suffix.result}"
  location      = "US"
  force_destroy = true
}

#
# output "bucket_fullname" {
#   value = google_storage_bucket.bucket[*].???
# }
#