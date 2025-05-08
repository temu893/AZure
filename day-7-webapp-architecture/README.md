# 🌍 Day 6: Terraform Multi-Environment Setup (Dev / Prod)

This project demonstrates a professional Terraform setup that isolates **dev** and **prod** infrastructure using:

- Reusable **modules**
- Independent **remote state files**
- Separate **variable inputs**
- Distinct **resource groups**

---

## ✅ What This Project Does

### 🔁 Environments:
- Creates **two fully separate environments**:
  - `TemDevOps-Dev`
  - `TemDevOps-Prod`
- Each environment:
  - Has its **own VNet**, subnets, and NSG
  - Uses its **own `.tfstate` file**
  - Is driven by its own `terraform.tfvars` config

### 📦 Modules:
- A shared `network` module under `modules/network/`:
  - Virtual Network
  - Multiple subnets
  - NSG with RDP rule
  - NSG-subnet association

### ☁️ Remote Backend:
- Terraform state is stored in a **central storage account** (`temdevopsstate`) in Azure under container `tfstate`
- Keys:
  - `dev.terraform.tfstate`
  - `prod.terraform.tfstate`

---

## 📁 Project Structure
day-6-env-split/\
├── dev/\
│ ├── backend.tf # Remote backend config\
│ ├── main.tf # Dev infra logic\
│ ├── variables.tf\
│ └── terraform.tfvars # Dev inputs\
├── prod/\
│ ├── backend.tf # Remote backend config\
│ ├── main.tf # Prod infra logic\
│ ├── variables.tf\
│ └── terraform.tfvars # Prod inputs\
├── modules/\
│ └── network/\
│ ├── main.tf # VNet, subnets, NSG logic\
│ ├── variables.tf\
│ └── outputs.tf\
└── README.md


---

⚙️ How to Deploy

🧪 Dev Environment
cd dev/
terraform init
terraform apply -var-file="terraform.tfvars"
🧪 Prod Environment
cd ../prod/
terraform init
terraform apply -var-file="terraform.tfvars"

| Concept           | Description                                          |
| ----------------- | ---------------------------------------------------- |
| ✅ Multi-env split | Isolates dev/prod to prevent accidental overwrites   |
| ✅ Remote backend  | Each env uses its own state file (`key = "..."`)     |
| ✅ Module reuse    | `network` module used by both environments           |
| ✅ Scoped input    | `terraform.tfvars` provides per-env configuration    |
| ✅ Resource safety | Dev and prod have separate resource groups and CIDRs |

| Problem | Solution |
| --- | --- |
| ❌ Terraform error: resource group not found | Passed `azurerm_resource_group.rg.name` into module instead of raw string to enforce dependency |
| ❌ `terraform init` failed | Backend RG/storage account had been deleted; recreated them before initializing |
| ❌ State file conflicts | Resolved by assigning unique backend `key` per environment |
| ❌ Incorrect module path | Fixed by using `source = "../modules/network"` in env `main.tf` |
| ❌ Used shared RG for state and infra | Split into 3 RGs: one for backend, one each for dev/prod |



👨‍💻 Author
------------

Built by [@temu893](https://github.com/temu893) as part of a Cloud/DevOps learning challenge.