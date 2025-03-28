# Getting HTTP from MonacoCloud application profiles for nat AND firewall rules
data "vcd_nsxt_app_port_profile" "http" {

  scope = "SYSTEM"
  name  = "HTTP"
}

# Getting HTTPS from MonacoCloud application profiles for nat AND firewall rules
data "vcd_nsxt_app_port_profile" "https" {

  scope = "SYSTEM"
  name  = "HTTPS"
}

# Getting SSH from MonacoCloud application profiles for nat AND firewall rules
data "vcd_nsxt_app_port_profile" "ssh" {

  scope = "SYSTEM"
  name  = "SSH"
}

# Getting kubectl from  application profiles for nat AND firewall rules
data "vcd_nsxt_app_port_profile" "K8s" {

  scope = "TENANT"
  name  = "kubernetes"
}

# Getting HTTP to node port application profiles for nat AND firewall rules
data "vcd_nsxt_app_port_profile" "http-nodeport" {

  scope = "TENANT"
  name  = "http-nodeport"
}

# Getting HTTPS from MonacoCloud application profiles for nat AND firewall rules
data "vcd_nsxt_app_port_profile" "https-nodeport" {

  scope = "TENANT"
  name  = "https-nodeport"
}

data "vcd_nsxt_alb_edgegateway_service_engine_group" "premium" {
  edge_gateway_id = var.edge_id
  service_engine_group_name = "LB_Shared"
}

