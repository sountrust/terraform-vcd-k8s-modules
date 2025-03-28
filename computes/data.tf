# Calling sizing policies dynamically based on var.vms_sizes
data "vcd_vm_sizing_policy" "k8s_cluster" {
  for_each = var.sizing_policy_names
  name = each.value
}


