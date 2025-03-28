output "vapp_template_out_id" {
  description = "The ID of the vApp template"
  value       = data.vcd_catalog_vapp_template.K8s_cluster.id
}

