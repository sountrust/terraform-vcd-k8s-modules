# VAPP org network output name
output "vapp_net_out_name" {
  value = vcd_vapp_org_network.k8s_cluster.org_network_name
}

# Dynamic set1 vms outputs for DNAT rules
output "dnat_master_ssh_ports" {
  value = {
    for idx, ip in var.master_ip_addresses : tostring(idx + 1) => var.env_ssh_port + idx
  }
}

output "dnat_worker_ssh_ports" {
  value = {
    for idx, ip in var.worker_ip_addresses : tostring(idx + 1) => local.worker_ssh_start_port + idx
  }
}
