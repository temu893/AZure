# 🚀 Day 4: CI/CD for Azure Infrastructure Using Terraform & GitHub Actions

This project automates the provisioning of a complete Azure infrastructure stack using **Terraform** and **GitHub Actions**. Infrastructure is deployed securely and repeatably through a CI/CD pipeline triggered by changes to the `main` branch.

---

## ✅ What I Built

The CI/CD pipeline provisions the following **10 Azure resources**:

| Resource Type                                 | Description                                       |
|----------------------------------------------|---------------------------------------------------|
| `azurerm_resource_group`                     | Logical container for all other resources         |
| `azurerm_virtual_network`                    | VNet (`10.0.0.0/16`) for network isolation        |
| `azurerm_subnet` (x2)                        | Two subnets for app and data separation           |
| `azurerm_network_security_group`            | NSG with RDP (3389) rule restricted by IP         |
| `azurerm_network_security_rule`             | Inbound RDP rule for secure access                |
| `azurerm_subnet_network_security_group_association` | NSG bound to SubnetA                  |
| `azurerm_public_ip`                          | Static public IP for VM                           |
| `azurerm_network_interface`                 | NIC connected to SubnetA with public IP & NSG     |
| `azurerm_windows_virtual_machine`           | Windows Server 2019 VM, size `Standard_DS1_v2`    |

---

## 🔁 CI/CD Pipeline Behavior

| Trigger        | Action Taken                     |
|----------------|----------------------------------|
| Push to `main` | Full `terraform plan` + `apply`  |
| PR to `main`   | `terraform plan` only (no apply) |

The pipeline runs:

- `terraform init`
- `terraform fmt -check`
- `terraform validate`
- `terraform plan`
- `terraform apply -auto-approve` *(only on `main` branch)*

---

## 🔐 Secrets Management

GitHub Secrets are used for secure Azure authentication and runtime configuration:

| Secret Name             | Purpose                                |
|-------------------------|----------------------------------------|
| `ARM_CLIENT_ID`         | Azure SP App ID                        |
| `ARM_CLIENT_SECRET`     | Azure SP password                      |
| `ARM_SUBSCRIPTION_ID`   | Azure Subscription ID                  |
| `ARM_TENANT_ID`         | Azure Tenant ID                        |
| `TF_VAR_admin_username` | Windows VM admin username              |
| `TF_VAR_admin_password` | Windows VM admin password              |
| `TF_VAR_admin_ip`       | IP range allowed to RDP into the VM    |

Secrets are passed using environment variables and `-var` flags in the GitHub Actions workflow.

---

## ❌ Issues I Faced & How I Solved Them

### 1. GitHub Action Not Triggering
**Cause**: Workflow file in wrong path, incorrect `working-directory`, or branch mismatch.  
**Fix**: Moved `.yml` to `.github/workflows/`, committed on `main`, updated `on:` block.

---

### 2. Terraform Hangs Silently
**Cause**: Missing required variables like `subscription_id`, `tenant_id`, `admin_ip`.  
**Fix**: Added these as GitHub Secrets and referenced them in the workflow.

---

### 3. 403 Authorization Errors
**Cause**: SP lacked Contributor access to the subscription.  
**Fix**: Recreated SP using:

```bash
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>"
Then updated ARM_CLIENT_ID, ARM_CLIENT_SECRET, and ARM_TENANT_ID in GitHub Secrets.

4. Wrong SP Permissions and Stale Credentials
Fix: Deleted the broken SP using:

bash
Copy
Edit
az ad sp delete --id <OLD_CLIENT_ID>
Created a shell script (cleanup-sp.sh) to automate SP cleanup and avoid future conflicts.

5. Terraform Not Finding Files
Cause: Incorrect use of working-directory set to a .tf file instead of the folder.
Fix: Updated to:

yaml
Copy
Edit
working-directory: ./Day-4-Automate-Terraform-with-GitHub-Actions
6. Secrets Not Found in Workflow
Fix: Verified secret names exactly match TF_VAR_ pattern, and removed paths: filter from on: trigger block.

7. Resource Duplication on Re-run
Fix: Ensured terraform.tfstate stays in Codespace and doesn't get reset.
🟡 Next step: Migrate state to remote backend using Azure Blob Storage with state locking.

azure-practice/
├── Day-4-Automate-Terraform-with-GitHub-Actions/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars  (not committed)
│   └── ...
├── .github/
│   └── workflows/
│       └── terraform.yml

🧪 How to Reuse This
Create your own Azure SP and set GitHub Secrets

Copy this project folder into your repo

Adjust variables in terraform.tfvars

Push to main → infrastructure is deployed automatically

