variable "prefix_name" {
  type = string
  description = "A prefix to add to all created resources for this project"
  # default = ""
}

variable "subnet_cidr" {
  type = string
  description = "CIDR for subnet"
  default = "192.168.0.0/24"
}

variable "gcp_region" {
  type = string
  description = "Google Cloud Default Region"
  default = "us-central1"
}

variable "vm_username" {
  type = string
  default = "debian"
}
