# 🚀 Day 7: Web App Architecture with Tiered NSGs + Secure CI/CD

## ✅ What I Built

This project sets up a production-grade web application infrastructure using Terraform and GitHub Actions. It includes:

- A VNet with **three subnets**: `web`, `app`, and `db`, each isolated.
- **Three NSGs**, each with strict access control rules:
  - Web NSG allows HTTP traffic from the Internet.
  - App NSG only allows traffic from the Web subnet.
  - DB NSG only allows traffic from the App subnet (port 1433).
- A **Linux VM** is deployed into the web subnet to simulate the web tier.
- **Separate environments (`dev` and `prod`)** with isolated state and input variables.
- **Secure CI/CD** pipelines using GitHub Actions:
  - Auto-deploy on push to `dev` branch.
  - `terraform plan` gated on PRs.
  - `terraform apply` requires manual approval in the `prod` environment.



## 🔐 GitHub CI/CD Setup

- **Secrets** used:
  - `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`
  - `ADMIN_USERNAME`, `ADMIN_PASSWORD`, `ADMIN_IP`
- **Environment-based workflows**:
  - `dev.yml`: auto-runs for `dev` branch
  - `prod.yml`: runs for `prod`, gated with manual approval
- **Secure deployment**:
  - State files stored in Azure Blob Storage
  - Sensitive variables passed via `-var` flags (not committed)

## 🧱 Folder Structure
day-7-webapp-architecture/\
├── modules/\
│ └── network/ # Reusable networking module (VNet, subnets, NSGs)\
├── dev/\
│ ├── main.tf\
│ ├── variables.tf\
│ ├── backend.tf\
│ └── terraform.tfvars # Not committed (in .gitignore)\
├── prod/\
│ ├── main.tf\
│ ├── variables.tf\
│ ├── backend.tf\
│ └── terraform.tfvars\
└── .github/\
└── workflows/\
├── dev.yml\
└── prod.yml



## 🔐 GitHub Actions Setup

- **`dev.yml`**: auto-runs `plan` and `apply` on the `dev` branch.
- **`prod.yml`**: runs `plan` on PR, and requires manual approval for `apply`.
- Uses **GitHub Environments** (`prod`) to enforce reviewer protection.
- All secrets (ARM credentials, admin credentials, IPs) stored in **GitHub Secrets**.

## 🧠 Lessons Learned

- Terraform modules make the architecture reusable, scalable, and easier to manage.
- NSGs are *not optional* — without them, all subnets are wide open by default.
- GitHub Actions with `environment:` and branch protections add a real security layer.
- Multi-environment infra is not just best practice — it's essential to prevent accidents.

## ❗ Issues Faced & Solved

- **Terraform plan stuck / prompts for input** → Solved by passing `-var` flags instead of relying on `terraform.tfvars` (which is `.gitignore`d).
- **State locking errors** → Handled using retry and understanding how Terraform locks remote state files.
- **Invalid syntax or missing outputs** in module → Fixed by explicitly exporting `subnet_ids` and referencing them properly in `dev/main.tf`.
- **Terraform Apply hanging in CI** → Happened due to missing required variables; solved by passing secrets explicitly.
- **GitHub Action not triggering** → Caused by wrong `branches:` config or previous `.yml` file still in place.


https://euangoddard.github.io/clipboard2markdown/ 

👨‍💻 Author
------------

Built by [@temu893](https://github.com/temu893) as part of a Cloud/DevOps learning challenge.