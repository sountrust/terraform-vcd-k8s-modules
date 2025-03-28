resource "vcd_independent_disk" "master_data" {
  count        = var.master_count
  name         = "master-${count.index + 1}-data-${var.env_deployment}"
  size_in_mb   = var.dmaster_data_size
  bus_type     = "SCSI"
  bus_sub_type = "VirtualSCSI"
}

resource "vcd_independent_disk" "master_fs" {
  count        = var.master_count
  name         = "master-${count.index + 1}-fs-${var.env_deployment}"
  size_in_mb   = var.dmaster_fs_size
  bus_type     = "SCSI"
  bus_sub_type = "VirtualSCSI"
}

resource "vcd_independent_disk" "worker_data" {
  count        = var.worker_count
  name         = "worker-${count.index + 1}-data-${var.env_deployment}"
  size_in_mb   = var.dworker_data_size
  bus_type     = "SCSI"
  bus_sub_type = "VirtualSCSI"
}

#resource "vcd_independent_disk" "worker_fs" {
#  count        = var.worker_count
#  name         = "worker-${count.index + 1}-fs-${var.env_deployment}"
#  size_in_mb   = var.dworker_fs_size
#  bus_type     = "SCSI"
#  bus_sub_type = "VirtualSCSI"
#}
