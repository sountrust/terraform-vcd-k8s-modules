# NSXT edgegateway id variable declaration 
variable "edge_id" {
  type = string
  sensitive = true
}

# NSXT edgegateway name variable declaration 
variable "edge_name" {
  type = string
  sensitive = true
}

# VDC group id variable declaration 
variable "vdc_group_id" {
  type = string
  sensitive = true
}

variable "env_deployment" {
  description = "Deployment environment"
  type = string
}

variable "environment_network" {
  description = "Subnetwork related to the deployment environment"
  type = string
}

# VAPP network variable declaration 
variable "vapp_name" {
  type = string
  sensitive = true
}

variable "public_ip" {
  description = "Public IP related to the deployment environment"
  type = string
}


variable "master_hostnames" {
  description = "Hostnames of master VMs"
  type = list(string)
}

variable "worker_hostnames" {
  description = "Hostnames of worker VMs"
  type = list(string)
}

variable "master_ip_addresses" {
  description = "Ip Addresses of master VMs"
  type = list(string)
}

variable "worker_ip_addresses" {
  description = "Ip Addresses of worker VMs"
  type = list(string)
}

variable "env_ssh_port" {
  description = "SSH port related to the deployment environment"
  type = number
}

variable "env_kubectl_port" {
  description = "kubectl port related to the deployment environment"
  type = number
}

variable "env_http_port" {
  description = "http port related to the deployment environment"
  type = number
}

variable "env_https_port" {
  description = "https port related to the deployment environment"
  type = number
}

variable "dns_servers" {
  description = "DNS servers for VM configuration"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}
