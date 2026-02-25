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

variable "project_id" {
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

variable "block_disks" {
  type = map
  description = "A map of disks to create 'disk_name' = 'disk_size_in_GB' "
  default = {
    disk1 = {
      size_GB = 20,
      type = "pd-ssd"
    }
    disk2 = {
      size_GB = 10,
      type = "pd-ssd"
    }
    disk3 = {
      size_GB = 5,
      type = "pd-ssd"
    }
  }
}