🧱 Day 5: Modular Terraform Infrastructure with Remote State in Azure
=====================================================================

[](https://github.com/temu893/azure-practice/tree/main/day-5-modules-remote-state#-day-5-modular-terraform-infrastructure-with-remote-state-in-azure)

This project refactors the infrastructure deployment using Terraform modules and configures a remote backend in Azure Storage to securely manage Terraform state across teams.

* * * * *

✅ What This Project Does
------------------------

[](https://github.com/temu893/azure-practice/tree/main/day-5-modules-remote-state#-what-this-project-does)

-   🔁 Converts a flat Terraform file into a reusable `network` module
-   🌐 Deploys:
    -   Azure Virtual Network (VNet)
    -   Two Subnets
    -   Network Security Group (NSG) + NSG Rule (Allow RDP from specific IP)
-   ☁️ Stores Terraform state in an Azure Storage Account backend
-   🔐 Secures access with service principal credentials and IP restrictions

* * * * *

📁 Project Structure
--------------------

day-5-modules-remote-state/\
├── main.tf # Uses module + backend\
├── variables.tf # Declares input variables\
├── terraform.tfvars # (gitignored) sets actual values\
├── outputs.tf # Outputs from root\
├── modules/\
│ └── network/\
│ ├── main.tf # VNet, Subnets, NSG\
│ ├── variables.tf # Module inputs\
│ └── outputs.tf # Module outputs


🧠 Key Concepts
---------------

[](https://github.com/temu893/azure-practice/tree/main/day-5-modules-remote-state#-key-concepts)

### 📦 Modules

[](https://github.com/temu893/azure-practice/tree/main/day-5-modules-remote-state#-modules)

-   Modularized networking into `modules/network/`
-   Accepts variables like VNet CIDR, subnet CIDRs, admin IP
-   Enables reuse across environments (dev, prod, etc.)

### ☁️ Remote State with Azure

[](https://github.com/temu893/azure-practice/tree/main/day-5-modules-remote-state#%EF%B8%8F-remote-state-with-azure)

-   Used `azurerm` backend with:
    -   Resource Group: `TemDevOps`
    -   Storage Account: `temdevopsstate`
    -   Container: `tfstate`
    -   Blob: `prod.terraform.tfstate`

* * * * *

🔐 Authentication
-----------------

[](https://github.com/temu893/azure-practice/tree/main/day-5-modules-remote-state#-authentication)

Used a service principal with Contributor rights and provided credentials via environment variables:

export TF_VAR_subscription_id="..."

export TF_VAR_tenant_id="..."

export TF_VAR_admin_username="..."

export TF_VAR_admin_password="..."

export TF_VAR_admin_ip="203.0.113.10/32"

✅ How to Run
------------

`terraform init        # Connects to remote backend
terraform plan        # Previews changes
terraform apply       # Deploys infrastructure`

❌ Issues I Faced & Solved
-------------------------

| Problem | Solution |
| --- | --- |
| Backend `init` asked to migrate state | Chose "no" to start fresh in remote |
| Terraform hung on apply | Missing variables --- fixed by exporting TF_VAR_* |

👨‍💻 Author
------------

Built by [@temu893](https://github.com/temu893) as part of a Cloud/DevOps learning challenge.