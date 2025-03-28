# Network Module for Kubernetes Cluster

This Terraform module provisions all network-related infrastructure for a Kubernetes cluster deployed in MonacoCloud’s NSX-T backed VMware vCloud Director (vCD) environment. It handles routed network creation, IP allocation, NAT rules, load balancers (via NSX-T ALB), and firewall application profile bindings for a fully operational tenant-level environment.

## 🔧 Features

- **NSX-T Routed Network** for cluster communication
- **VApp Network Attachment** to bind the routed Org network to the Kubernetes VApp
- **Dynamic IP Sets** for masters and workers
- **NAT Rules**:
  - SNAT for cluster-to-internet communication
  - DNAT for accessing masters and workers over SSH
  - DNAT for accessing Kubernetes API, HTTP/S NodePorts
- **NSX-T Load Balancers (ALB)**:
  - Pools and Virtual Services for:
    - `k8s-api` (masters:6443)
    - `k8s-http` (workers:30080)
    - `k8s-https` (workers:30443)

## 📁 Structure

| File           | Description                                     |
|----------------|-------------------------------------------------|
| `main.tf`      | Core resources: Org network, IP sets, VApp link |
| `nat.tf`       | NAT rules for SNAT and DNAT                     |
| `lb.tf`        | Load Balancer pools and virtual services        |
| `data.tf`      | Application profiles and service engine group   |
| `variables.tf` | Input variable definitions                      |
| `outputs.tf`   | Output variables (network name, DNAT ports)     |

## 🚀 Usage

This module is intended to be consumed from a higher-level environment layer such as `/terraform/apply`. Example:

```hcl
module "networks" {
  source              = "../modules/networks"
  edge_id             = var.edge_id
  edge_name           = var.edge_name
  vdc_group_id        = var.vdc_group_id
  env_deployment      = var.env_deployment
  environment_network = var.environment_network
  vapp_name           = var.vapp_name
  public_ip           = var.public_ip
  master_hostnames    = var.master_hostnames
  worker_hostnames    = var.worker_hostnames
  master_ip_addresses = var.master_ip_addresses
  worker_ip_addresses = var.worker_ip_addresses
  env_ssh_port        = var.env_ssh_port
  env_kubectl_port    = var.env_kubectl_port
  env_http_port       = var.env_http_port
  env_https_port      = var.env_https_port
}
```

## 📤 Outputs

| Output Name             | Description                                |
|-------------------------|--------------------------------------------|
| `vapp_net_out_name`     | Name of the created Org VDC network        |
| `dnat_master_ssh_ports` | Mapping of master node index to SSH port   |
| `dnat_worker_ssh_ports` | Mapping of worker node index to SSH port   |

## 🔗 Dependencies

- Assumes:
  - A VApp already exists (`var.vapp_name`)
  - `edge_id` and `edge_name` refer to an NSX-T enabled Edge Gateway
- Requires ALB service engine group named `LB_Shared`
- Application port profiles must exist in both SYSTEM and TENANT scopes

## 🧠 Notes

- SSH DNAT ports are calculated dynamically from a base port
- Default port assumptions:
  - API: `6443`
  - HTTP: `30080`
  - HTTPS: `30443`
- Virtual services use IPs in the `.100–.102` range of the subnet

## 📌 Example Port Mapping

| Purpose       | IP              | Port   |
|---------------|------------------|--------|
| K8s HTTP      | `${env_net}.100` | 30080  |
| K8s HTTPS     | `${env_net}.101` | 30443  |
| K8s API       | `${env_net}.102` | 6443   |
| SSH (masters) | DNAT via Public IP | Dynamic |
| SSH (workers) | DNAT via Public IP | Dynamic |

## 🛡️ Security

- DNAT/Port forwarding uses `MATCH_EXTERNAL_ADDRESS` to tightly scope exposure
- Port profiles ensure only explicitly allowed services are reachable
