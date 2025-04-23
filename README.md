# Terraform Modules – Cloud Project

This directory is a standalone Git submodule used for VCloud Director infrastructure-as-code stack. It contains all reusable, isolated Terraform modules required to provision Kubernetes-based environments in a vCloud Director (vCD) context.

---

## 📦 Modules

| Module     | Description                                                              |
|------------|--------------------------------------------------------------------------|
| `catalogs` | Retrieves and exposes vApp templates from a vCD catalog.                 |
| `computes` | Provisions compute resources (VMs, disks, VApps) for K8s clusters.       |
| `networks` | Builds and exposes network layers including NAT, LB, and routed VDCs.    |

Each module is designed to be self-contained, composable, and used by upper-level orchestration layers (e.g., `terraform/apply`).

---

## 🧭 Structure & Purpose

This Git submodule allows the core infrastructure logic to be versioned and reused independently of the environments that consume it.

- Promotes reuse across staging, pre-prod, and production.
- Ensures changes are traceable at the module level.
- Supports semantic versioning and submodule pinning in parent repos.

---

## 🚀 Usage

In a parent Terraform repo:

```hcl
module "networks" {
  source = "./modules/networks"
  ...
}

module "computes" {
  source = "./modules/computes"
  ...
}

module "catalogs" {
  source = "./modules/catalogs"
  ...
}
```

To initialize or update the submodule:

```bash
git submodule init
git submodule update --remote
```

Or to clone with submodules:

```bash
git clone --recurse-submodules <repo-url>
```

---

## 📌 Notes

- Each subfolder contains its own `README.md` for documentation.
- Do not edit module logic from within environment layers; maintain module logic here.
- Use semantic tags or branches to track module versions in different environments.

