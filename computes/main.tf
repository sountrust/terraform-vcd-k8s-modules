terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.11.0"
    }
  }
}

# VAPP creation
resource "vcd_vapp" "K8s_cluster" {
  name = "cluster_${var.env_deployment}"

  metadata_entry {
    key = "Decription"
    type = "MetadataStringValue"
    user_access = "READWRITE"
    is_system = false
    value = "Virtual app containing cluster ${var.env_deployment}"
  }
}

# Creating MASTER VM resource into above VAPP
resource "vcd_vapp_vm" "masters" {
  count = var.master_count
  vapp_name        = vcd_vapp.K8s_cluster.name
  name             = "master${count.index + 1}-${var.env_deployment}"
  os_type          = "ubuntu64Guest"
  vapp_template_id = var.vapp_template_id
  sizing_policy_id = data.vcd_vm_sizing_policy.k8s_cluster[var.sizing_master_key].id

  network {
    name               = var.vapp_network_name
    type               = "org"
    ip_allocation_mode = "POOL"
  }
  #Configuration to initiate vm with cloud-init
  guest_properties = {
    "user-data" = base64encode(templatefile("${path.module}/cloud-config.yaml", {
      hostname = "u2404-${var.sizing_master_key}-master${count.index + 1}-${var.env_deployment}",
      dns_servers = join(" ", var.dns_servers)
      k8s_api_ip     = "${var.environment_network}.102",
      k8s_api_domain = var.k8s_api_domain
    }))
  }

  disk {
    bus_number       = 0
    unit_number      = 1
    name             = vcd_independent_disk.master_data[count.index].name 
  }
  
  disk {
    bus_number       = 0
    unit_number      = 2
    name             = vcd_independent_disk.master_fs[count.index].name 
  }

}

# Creating worker VM resource into above VAPP
resource "vcd_vapp_vm" "workers" {
  count = var.worker_count
  vapp_name        = vcd_vapp.K8s_cluster.name
  name             = "worker${count.index + 1}-${var.env_deployment}"
  os_type          = "ubuntu64Guest"
  vapp_template_id = var.vapp_template_id
  sizing_policy_id = data.vcd_vm_sizing_policy.k8s_cluster[var.sizing_worker_key].id

  network {
    name               = var.vapp_network_name
    type               = "org"
    ip_allocation_mode = "POOL"
  }
  #Configuration to initiate vm with cloud-init
  guest_properties = {
    "user-data" = base64encode(templatefile("${path.module}/cloud-config.yaml", {
      hostname = "u2404-${var.sizing_worker_key}-worker${count.index + 1}-${var.env_deployment}",
      dns_servers = join(" ", var.dns_servers)
      k8s_api_ip     = "${var.environment_network}.102",
      k8s_api_domain = var.k8s_api_domain
    }))
  }

  disk {
    bus_number       = 0
    unit_number      = 1
    name             = vcd_independent_disk.worker_data[count.index].name 
  }
  
  # disk {
  #   bus_number       = 0
  #   unit_number      = 2
  #   name             = vcd_independent_disk.worker_fs[count.index].name 
  # }

}

