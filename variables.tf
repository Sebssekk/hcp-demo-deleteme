variable "prefix_name" {
  type = string
  description = "A prefix to add to all created resources for this project"
  # default = ""
}

variable "subnet_cidr" {
  type = string
  description = "CIDR for subnet"
  default = "192.168.0.0/24"

  validation {
    condition = can(cidrnetmask(var.subnet_cidr))
    error_message = "IS NOT A CIDR"
  }
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

variable "project_id" {
  type = string
  description = "GCP Project id"
}
variable "project_id2" {
  type = string
  description = "GCP Project id"
}

variable "vm_size" {
  type = string
  default = "e2-micro"
}

variable "second_instance_num" {
  type = number
  description = "Number of 'vm2' to create. If set to 0 Will not create it"
}

variable "bucket_prefix" {
  type = set(string)
  description = "It will create one bucket per prefix"
  default = [ "log", "data","conf"]
}

variable "extra_disks" {
  description = "list of disk size to attach to vm"
  default = [ 20, 10 , 5]
  type = list(number)
}
variable "extra_disks_type" {
  description = "type of extra disks"
  default = "pd-ssd"
  type = string
}
# variable "block_disks" {
#   type = map
#   description = "A map of disks to create 'disk_name' = 'disk_size_in_GB' "
#   default = {
#     disk1 = {
#       size_GB = 20,
#       type = "pd-ssd"
#     }
#     disk2 = {
#       size_GB = 10,
#       type = "pd-ssd"
#     }
#     disk3 = {
#       size_GB = 5,
#       type = "pd-ssd"
#     }
#   }
# }

variable "demo_gcp_regions" {
  type = list(string)
  default = [ "us-central1", "us-west1" ]
}

variable "demo_gcp_per_region_zones" {
  type = list(string)
  default = [ "a", "b" ]

  validation {
    condition = setunion(["a","b","c"], toset(var.demo_gcp_per_region_zones)) == ["a","b","c"]    
    error_message = "value"
  }
}

locals {
  demo_output = flatten([ for idr,r in var.demo_gcp_regions : [ for idz,z in var.demo_gcp_per_region_zones : "vm-XX-${r}-${z}"]])
}

output "name" {
  # vm-0-us-central1-a
  # vm-1-us-central1-b
  # vm-2-us-west1-a
  # vm-3-us-west1-b
  value = local.demo_output
}