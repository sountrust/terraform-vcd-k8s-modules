variable "env_deployment" {
  description = "environment deployment"
  type = string
}

variable "sizing_policy_names" {
  description = "list of templated vm sizes"
  type = map(string)

  default = {
    "l" = "c.large",
    "x" = "c.xlarge",
    "2x" = "c.2xlarge",
    "4x" = "c.4xlarge",
    "5x" = "c.5xlarge"
  }
}

variable "worker_count" {
  description = "Number of workers"
  type        = number
}

variable "master_count" {
  description = "Number of masters vm"
  type        = number
}

variable "sizing_master_key" {
  description = "Key value to set master vm size"
  type        = string
}

variable "sizing_worker_key" {
  description = "Key value to set worker vm size"
  type        = string
}

variable "dmaster_data_size" {
  description = "Size of the master data disk"
  type        = number
}

variable "dworker_data_size" {
  description = "Size of the worker data disk"
  type        = number
}

variable "dmaster_fs_size" {
  description = "Size of the master NFS disk"
  type        = number
}

#variable "dworker_fs_size" {
#  description = "Size of the worker NFS disk"
#  type        = number
#}

variable "vapp_network_name" {
  description = "network for vm and vapp environment"
  type = string
}

variable "vapp_template_id" {
  description = "Temlpate used for vm in vapp"
  type = string
}

variable "dns_servers" {
  description = "DNS servers for VM configuration"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "k8s_api_domain" {
  description = "The domain part for the Kubernetes API server"
  type        = string
}

variable "environment_network" {
  description = "Subnetwork related to the deployment environment"
  type = string
}


