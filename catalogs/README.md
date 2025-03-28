# Catalog Module for Kubernetes Cluster

This Terraform module is responsible for retrieving vApp templates from a designated vCloud Director (vCD) catalog. It ensures that the correct Kubernetes base template is referenced by other modules (e.g., computes) during provisioning.

---

## 🔧 Features

- Fetches an existing **vCD catalog** by name.
- Resolves a **vApp template** inside that catalog using its name.
- Outputs the **template ID** for use in VM deployment modules.

---

## 📁 Structure

| File         | Description                              |
|--------------|------------------------------------------|
| `data.tf`    | Data lookups for catalog and vApp template |
| `outputs.tf` | Output values for template ID            |
| `variables.tf` | Input variables for catalog/template name |

---

## 🚀 Usage

This module is used in higher-level configurations to provide the template ID for virtual machine deployment:

```hcl
module "catalogs" {
  source              = "../modules/catalogs"
  catalog_name        = "Templates"
  vapp_template_name  = "ubuntu-22.04-k8s"
}
```

You can then reference the output:

```hcl
module.catalogs.vapp_template_out_id
```

---

## 📤 Outputs

| Output Name             | Description                            |
|--------------------------|----------------------------------------|
| `vapp_template_out_id`   | The resolved ID of the vApp template   |

---

## 🔗 Dependencies

- The vCD catalog (`catalog_name`) must exist in your organization.
- The vApp template (`vapp_template_name`) must be published and available in that catalog.

---

## 🧠 Notes

- This module performs a **read-only lookup** and does not create or modify resources.
- The retrieved ID is passed to the compute module for instantiating VMs.

