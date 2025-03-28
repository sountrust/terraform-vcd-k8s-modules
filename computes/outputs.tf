# Output for Vapp name
output "vapp_out_name" {
  value = vcd_vapp.K8s_cluster.name
  description = "IP addresses of Master VMs"
}

# Output for Master VM IP Addresses
output "master_ip_out_addresses" {
  value = [for master in vcd_vapp_vm.masters : master.network[0].ip]
  description = "IP addresses of Master VMs"
}

# Output for Master VM Hostnames
output "master_vm_out_hostnames" {
  value = [for idx, master in vcd_vapp_vm.masters : "u2404-${var.sizing_master_key}-master${idx + 1}-${var.env_deployment}"]
  description = "Hostnames of Master VMs"
}

# Output for Worker VM IP Addresses
output "worker_ip_out_addresses" {
  value = [for worker in vcd_vapp_vm.workers : worker.network[0].ip]
  description = "IP addresses of Worker VMs"
}

# Output for Worker VM Hostnames
output "worker_vm_out_hostnames" {
  value = [for idx, worker in vcd_vapp_vm.workers : "u2404-${var.sizing_worker_key}-worker${idx + 1}-${var.env_deployment}"]
  description = "Hostnames of worker VMs"
}
