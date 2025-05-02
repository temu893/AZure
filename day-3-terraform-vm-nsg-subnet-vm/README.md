# 🚀 Day 3: Azure Networking with Terraform

This project provisions a complete Azure network and VM infrastructure using Terraform. It includes a Virtual Network (VNet), subnets, a Network Security Group (NSG), and a Windows virtual machine (VM) — all managed declaratively via Infrastructure as Code.

---

## 🔧 Resources Provisioned

| Resource Type | Name / Description |
|---------------|--------------------|
| Resource Group | `TemDevOps` |
| Virtual Network | `MyVnet` (CIDR: 10.0.0.0/16) |
| SubnetA | 10.0.1.0/24 (VM tier) |
| SubnetB | 10.0.2.0/24 (future use or DB tier) |
| Network Security Group | `MyNSG` with inbound RDP rule |
| NSG Rule | Allows TCP 3389 from a specified public IP |
| Public IP | Assigned statically to VM |
| Network Interface (NIC) | Connected to SubnetA with NSG |
| Virtual Machine | Windows Server 2019 (`Standard_DS1_v2`) |

---

## 📘 Key Terraform Concepts Used

### ✅ State Management

Terraform tracks deployed resources using a **state file (`terraform.tfstate`)**, which maps your code to the real Azure infrastructure. This allows Terraform to:
- Detect drift
- Plan updates
- Avoid manual mistakes

### ✅ Dependency Handling

Terraform automatically resolves resource dependencies using references (e.g., `azurerm_subnet.subnet_a.id`). In special cases, you can enforce order using `depends_on`.

### ✅ Sensitive Data Handling

No sensitive values are hardcoded. All secrets like `admin_password` and `subscription_id` are injected via:
- Environment variables (e.g., `TF_VAR_admin_password`)
- `.tfvars` files (ignored in Git)

---

## 🐛 Issues Faced

| Problem | Solution |
|--------|----------|
| `az login` failed with MFA errors | Used `az login --tenant TENANT_ID` to authenticate |
| Terraform error: "subscription_id required" | Explicitly passed `subscription_id` and `tenant_id` as variables |
| NSG rule failed due to wrong protocol | Changed `"TCP"` to `"Tcp"` (Terraform is case-sensitive) |
| Invalid IP CIDR in NSG rule | Added `/32` suffix to admin IP to make it valid |
| Applied from wrong directory | Used `cd` instead of trying to execute the folder |

---

## 🔐 Security Notes

- RDP is restricted to a specific public IP using `/32` CIDR
- Passwords are stored securely using Terraform's `sensitive = true` and not printed in outputs
- Public IPs and credentials are excluded from GitHub

---

## 💡 Future Improvements

- Replace RDP with Azure Bastion for secure VM access
- Move to remote state backend (Azure Storage) for collaboration
- Convert to reusable Terraform modules
