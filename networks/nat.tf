# SNAT rule for k8s_cluster to reach wan
resource "vcd_nsxt_nat_rule" "snat" {

  edge_gateway_id = var.edge_id

  name = "snat_${var.env_deployment}_rule"
  rule_type = "SNAT"
  description = "opening to wan cluster network via SNAT rule"
 
  external_address = var.public_ip
  internal_address = "${var.environment_network}.0/24"
  depends_on = [
    vcd_nsxt_alb_pool.k8s_https,
    vcd_nsxt_alb_pool.k8s_http,
    vcd_nsxt_alb_pool.k8s_api,
    vcd_nsxt_alb_virtual_service.k8s_https,
    vcd_nsxt_alb_virtual_service.k8s_http,
    vcd_nsxt_alb_virtual_service.k8s_api
  ]
}

# Dynamic block for set 1 DNAT rules
resource "vcd_nsxt_nat_rule" "dnat_master_ssh" {
  count = length(var.master_ip_addresses)

  edge_gateway_id    = var.edge_id
  name               = "dnat_ssh_${var.env_deployment}_master${count.index + 1}"
  rule_type          = "DNAT"
  description        = "opening ssh to cluster's vm via DNAT rule"
  external_address   = var.public_ip
  internal_address   = var.master_ip_addresses[count.index]
  dnat_external_port = var.env_ssh_port + count.index
  app_port_profile_id = data.vcd_nsxt_app_port_profile.ssh.id
  firewall_match     = "MATCH_EXTERNAL_ADDRESS"
  depends_on = [
    vcd_nsxt_alb_pool.k8s_https,
    vcd_nsxt_alb_pool.k8s_http,
    vcd_nsxt_alb_pool.k8s_api,
    vcd_nsxt_alb_virtual_service.k8s_https,
    vcd_nsxt_alb_virtual_service.k8s_http,
    vcd_nsxt_alb_virtual_service.k8s_api
  ]
}

locals {
  worker_ssh_start_port = var.env_ssh_port + length(var.master_ip_addresses)
}

resource "vcd_nsxt_nat_rule" "dnat_worker_ssh" {
  count = length(var.worker_ip_addresses)

  edge_gateway_id    = var.edge_id
  name               = "dnat_ssh_${var.env_deployment}_worker${count.index + 1}"
  rule_type          = "DNAT"
  description        = "opening ssh to cluster's worker vm via DNAT rule"
  external_address   = var.public_ip
  internal_address   = var.worker_ip_addresses[count.index]
  dnat_external_port = local.worker_ssh_start_port + count.index
  app_port_profile_id = data.vcd_nsxt_app_port_profile.ssh.id
  firewall_match     = "MATCH_EXTERNAL_ADDRESS"
  depends_on = [
    vcd_nsxt_alb_pool.k8s_https,
    vcd_nsxt_alb_pool.k8s_http,
    vcd_nsxt_alb_pool.k8s_api,
    vcd_nsxt_alb_virtual_service.k8s_https,
    vcd_nsxt_alb_virtual_service.k8s_http,
    vcd_nsxt_alb_virtual_service.k8s_api
  ]
}

# Kubernetes cluster DNAT rule
resource "vcd_nsxt_nat_rule" "dnat_K8s_master_kubectl" {
  edge_gateway_id    = var.edge_id
  name               = "dnat_K8s_master_${var.env_deployment}_kubectl_rule"
  rule_type          = "DNAT"
  description        = "opening kubectl to cluster's ${var.env_deployment} vm via DNAT rule"
  external_address   = var.public_ip
  internal_address   = "${var.environment_network}.102"
  dnat_external_port = var.env_kubectl_port
  app_port_profile_id = data.vcd_nsxt_app_port_profile.K8s.id
  firewall_match     = "MATCH_EXTERNAL_ADDRESS"
  depends_on = [
    vcd_nsxt_alb_pool.k8s_https,
    vcd_nsxt_alb_pool.k8s_http,
    vcd_nsxt_alb_pool.k8s_api,
    vcd_nsxt_alb_virtual_service.k8s_https,
    vcd_nsxt_alb_virtual_service.k8s_http,
    vcd_nsxt_alb_virtual_service.k8s_api
  ]
}

# HTTP cluster DNAT rule
resource "vcd_nsxt_nat_rule" "dnat_http_dev" {
  edge_gateway_id    = var.edge_id
  name               = "dnat_http_${var.env_deployment}_rule"
  rule_type          = "DNAT"
  description        = "opening HTTP to cluster's ${var.env_deployment} vm via DNAT rule"
  external_address   = var.public_ip
  internal_address   = "${var.environment_network}.100"
  dnat_external_port = var.env_http_port
  app_port_profile_id = data.vcd_nsxt_app_port_profile.http-nodeport.id
  firewall_match     = "MATCH_EXTERNAL_ADDRESS"
  depends_on = [
    vcd_nsxt_alb_pool.k8s_https,
    vcd_nsxt_alb_pool.k8s_http,
    vcd_nsxt_alb_pool.k8s_api,
    vcd_nsxt_alb_virtual_service.k8s_https,
    vcd_nsxt_alb_virtual_service.k8s_http,
    vcd_nsxt_alb_virtual_service.k8s_api
  ]
}

# HTTPS cluster DNAT rule
resource "vcd_nsxt_nat_rule" "dnat_https_dev" {
  edge_gateway_id    = var.edge_id
  name               = "dnat_https_${var.env_deployment}_rule"
  rule_type          = "DNAT"
  description        = "opening HTTP to cluster's ${var.env_deployment} vm via DNAT rule"
  external_address   = var.public_ip
  internal_address   = "${var.environment_network}.101"
  dnat_external_port = var.env_https_port
  app_port_profile_id = data.vcd_nsxt_app_port_profile.https-nodeport.id
  firewall_match     = "MATCH_EXTERNAL_ADDRESS"
  depends_on = [
    vcd_nsxt_alb_pool.k8s_https,
    vcd_nsxt_alb_pool.k8s_http,
    vcd_nsxt_alb_pool.k8s_api,
    vcd_nsxt_alb_virtual_service.k8s_https,
    vcd_nsxt_alb_virtual_service.k8s_http,
    vcd_nsxt_alb_virtual_service.k8s_api
  ]
}
