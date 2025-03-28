terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.11.0"
    }
  }
}

# Ip set refering to kubernetes in cluster_network
resource "vcd_nsxt_ip_set" "k8s_cluster" {
  edge_gateway_id = var.edge_id

  name = "cluster_${var.env_deployment}_IpSet"
  description = "IP Set containing IPv4 and IPv6 ranges for ${var.env_deployment} environment"

  ip_addresses = [
    "${var.environment_network}.0/24"
  ]
}

# Ip set refering to masters in cluster_network
resource "vcd_nsxt_ip_set" "masters" {
  edge_gateway_id = var.edge_id
  name = "masters${var.env_deployment}_IpSet"
  description = "IP Set containing IPv4 addresses for masters in ${var.env_deployment} environment"
  ip_addresses = var.master_ip_addresses
}

# Ip set refering to workers in cluster_network
resource "vcd_nsxt_ip_set" "workers" {
  edge_gateway_id = var.edge_id
  name = "workers${var.env_deployment}_IpSet"
  description = "IP Set containing IPv4 addresses for workers in ${var.env_deployment} environment"
  ip_addresses = var.worker_ip_addresses
}

# Create a new network in organization VDC defined in branch_name folder
resource "vcd_network_routed_v2" "k8s_cluster" {
  name = "k8s_cluster_${var.env_deployment}"
  description = "Routed Org VDC staging network backed by NSX-T"

  edge_gateway_id = var.edge_id

  gateway = "${var.environment_network}.254"

  prefix_length = 24

  static_ip_pool {
    start_address = "${var.environment_network}.10"
    end_address = "${var.environment_network}.60"
  }
}

# Create a new vapp network in organization VDC defined in branch_name folder
resource "vcd_vapp_org_network" "k8s_cluster" {
  vapp_name = var.vapp_name
  org_network_name = vcd_network_routed_v2.k8s_cluster.name
  reboot_vapp_on_removal = true
}


