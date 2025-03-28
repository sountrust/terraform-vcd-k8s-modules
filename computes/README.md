# Compute Module for Kubernetes Cluster

This module provisions compute infrastructure (VMs and disks) in a MonacoCloud vCloud Director (vCD) environment for Kubernetes master and worker nodes. It handles VApp creation, dynamic VM deployment using sizing policies, independent disk attachment, and full OS configuration through cloud-init.

---

## 🔧 Features

- Creates a dedicated **VApp** for the Kubernetes cluster
- Dynamically provisions **master and worker VMs** with cloud-init
- Supports **custom VM sizing policies** using `vcd_vm_sizing_policy`
- Attaches **independent disks** (data and NFS) to each VM
- Injects **DNS and network config** through `cloud-config.yaml`

---

## 📁 Structure

| File               | Description                                           |
|--------------------|-------------------------------------------------------|
| `main.tf`          | VApp and VM resource definitions                      |
| `disk.tf`          | Independent disk creation per node                    |
| `cloud-config.yaml`| Cloud-init template for OS-level setup                |
| `data.tf`          | Lookup for VM sizing policies                         |
| `variables.tf`     | Input variables for compute config                    |
| `outputs.tf`       | Output values (IP addresses, hostnames)              |

---

## 🚀 Usage

This module is typically invoked from a higher-level orchestration layer like `/terraform/apply`.

```hcl
module "computes" {
  source = "../modules/computes"

  env_deployment       = var.env_deployment
  sizing_policy_names  = var.sizing_policy_names
  sizing_master_key    = "x"
  sizing_worker_key    = "l"

  master_count         = 3
  worker_count         = 2

  dmaster_data_size    = 51200
  dmaster_fs_size      = 20480
  dworker_data_size    = 51200

  vapp_network_name    = var.vapp_network_name
  vapp_template_id     = var.vapp_template_id

  dns_servers          = ["8.8.8.8", "8.8.4.4"]
  k8s_api_domain       = "k8s.cluster.internal"
  environment_network  = "192.168.0"
}
```

---

## 📤 Outputs

| Output Name               | Description                             |
|---------------------------|-----------------------------------------|
| `vapp_out_name`           | Name of the created VApp                |
| `master_ip_out_addresses` | List of master VM IPs                   |
| `worker_ip_out_addresses` | List of worker VM IPs                   |
| `master_vm_out_hostnames` | Computed hostnames for master VMs       |
| `worker_vm_out_hostnames` | Computed hostnames for worker VMs       |

---

## 🧠 Cloud-Init Notes

The module uses a `cloud-config.yaml` template to configure:
- Hostnames and DNS
- A default user with bash shell access
- Systemd-resolved for DNS handling
- Custom `/etc/hosts` file with Kubernetes API resolution
- Optional package installation (`jq`, `python3-pip`)

All properties are injected using `guest_properties["user-data"]`.

---

## 🔗 Dependencies

- vApp template (`vapp_template_id`) must be compatible with cloud-init (e.g., Ubuntu).
- Independent disks must be supported by your vCD org.
- Sizing policies must exist and match the names passed via `sizing_policy_names`.

---

## 🛑 Known Limitations

- `worker_fs` disk is currently disabled (see commented code in `disk.tf`)
- Sizing is controlled by key-value pairs (`"x"` → `"c.xlarge"` etc.)
- VM name and hostname patterns are hardcoded but predictable

---

## 🛡️ Security

- DNS and host resolution are tightly controlled by provisioning templates.
- Users can extend `cloud-config.yaml` to include SSH keys or hardening steps.
