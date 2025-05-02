# Day 2: Azure Networking — VNet, Subnets, NSG, VM (CLI)

## 🛠️ What I Built

- A Virtual Network (`MyVnet`) with address space `10.0.0.0/16`
- Two subnets:
  - SubnetA: `10.0.1.0/24`
  - SubnetB: `10.0.2.0/24`
- A Network Security Group (`MyNSG`) attached to SubnetA
- An inbound NSG rule to allow RDP (port 3389)
- A public IP + NIC associated with SubnetA and NSG
- A Windows VM (`MyWindowVM`) deployed in SubnetA

## 🔐 Why I Configured NSG This Way

- I allowed **RDP only (port 3389)** to enable remote access to the Windows VM
- All other inbound traffic is denied by default (zero-trust)
- NSG is applied at the **subnet level** to enforce consistent rules for all resources in SubnetA

## ❗ Issue Faced

- Got an error: `--address-prefixes: expected at least one argument`  
  ✅ Solved by correcting the flag from `--address-prefix` → `--address-prefixes`
  
- Forgot `--nsg-name` in `az network nsg rule create`  
  ✅ Fixed by retyping the full flag name correctly

## 💡 Lesson Learned

- Always check parameter names — Azure CLI flags are strict and will fail silently if incorrect
- NSG must be applied explicitly — it doesn’t automatically link to subnets or NICs
- Creating resources via script is **much faster and reproducible** than doing it in the Portal

