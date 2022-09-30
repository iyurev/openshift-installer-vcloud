variable "network_type" {
  type = "string"
  default = "org"
}


variable "vcd_pass" {
  type = "string"

}

variable "cri_storage_disk" {
  type = "string"
  default = "/dev/sdb"
}

variable "cri_storage_label" {
  type = "string"
  default = "CRI"
}

variable "cri_storage_path" {
  type = "string"
  default = "/var/lib/containers/storage"
}

variable "cri_mount_systemd_unit_name" {
  type = "string"
  default = "var-lib-containers-storage"
}

variable "nexus_username" {
  type = "string"
}
variable "nexus_pass" {
  type = "string"
}

variable "nexus_proto" {
  type = "string"
  default = "https"
}






