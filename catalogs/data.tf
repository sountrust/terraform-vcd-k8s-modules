terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.11.0"
    }
  }
}

data "vcd_catalog" "custom_catalog" {
  name = var.catalog_name
}

# Existing VAPP template declaration
data "vcd_catalog_vapp_template" "K8s_cluster" {
  catalog_id = data.vcd_catalog.custom_catalog.id
  name    = var.vapp_template_name
}

