resource "vcd_nsxt_alb_pool" "k8s_http" {
  edge_gateway_id = var.edge_id
  name            = "k8s-http-${var.env_deployment}-workers-pool"
  algorithm = "ROUND_ROBIN"
  default_port = 30080 
  graceful_timeout_period = "1"
  passive_monitoring_enabled = true
  persistence_profile {
    type = "CLIENT_IP"
  }

  health_monitor {
    type= "TCP"
  }

  member_group_id = vcd_nsxt_ip_set.workers.id
}

resource "vcd_nsxt_alb_virtual_service" "k8s_http" {

  name            = "k8s-http-${var.env_deployment}-virtualService"
  edge_gateway_id = var.edge_id

  pool_id                  = vcd_nsxt_alb_pool.k8s_http.id
  service_engine_group_id  = data.vcd_nsxt_alb_edgegateway_service_engine_group.premium.service_engine_group_id
  virtual_ip_address       = "${var.environment_network}.100"
  application_profile_type = "L4"
  service_port {
    start_port = 30080
    type       = "TCP_FAST_PATH"
  }
}

resource "vcd_nsxt_alb_pool" "k8s_https" {
  edge_gateway_id = var.edge_id
  name            = "k8s-https-${var.env_deployment}-workers-pool"
  algorithm = "ROUND_ROBIN"
  default_port = 30443 
  graceful_timeout_period = "1"
  passive_monitoring_enabled = true
  persistence_profile {
    type = "CLIENT_IP"
  }

  health_monitor {
    type= "TCP"
  }

  member_group_id = vcd_nsxt_ip_set.workers.id
}

resource "vcd_nsxt_alb_virtual_service" "k8s_https" {

  name            = "k8s-https-${var.env_deployment}-virtualService"
  edge_gateway_id = var.edge_id

  pool_id                  = vcd_nsxt_alb_pool.k8s_https.id
  service_engine_group_id  = data.vcd_nsxt_alb_edgegateway_service_engine_group.premium.service_engine_group_id
  virtual_ip_address       = "${var.environment_network}.101"
  application_profile_type = "L4"
  service_port {
    start_port = 30443
    type       = "TCP_FAST_PATH"
  }
}

resource "vcd_nsxt_alb_pool" "k8s_api" {
  edge_gateway_id = var.edge_id
  name            = "k8s-api-${var.env_deployment}-masters-pool"
  algorithm = "ROUND_ROBIN"
  default_port = 6443 
  graceful_timeout_period = "1"
  passive_monitoring_enabled = true
  persistence_profile {
    type = "CLIENT_IP"
  }

  health_monitor {
    type= "TCP"
  }

  member_group_id = vcd_nsxt_ip_set.masters.id

}

resource "vcd_nsxt_alb_virtual_service" "k8s_api" {

  name            = "k8s-api-${var.env_deployment}-virtualService"
  edge_gateway_id = var.edge_id

  pool_id                  = vcd_nsxt_alb_pool.k8s_api.id
  service_engine_group_id  = data.vcd_nsxt_alb_edgegateway_service_engine_group.premium.service_engine_group_id
  virtual_ip_address       = "${var.environment_network}.102"
  application_profile_type = "L4"
  service_port {
    start_port = 6443
    type       = "TCP_FAST_PATH"
  }
}
