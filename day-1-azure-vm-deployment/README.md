## VM Deployment with Azure CLI

In this session, I deployed a virtual machine (VM) using the Azure CLI. The command used to create the VM is:

az vm create \
  --name <VM-NAME> \
  --resource-group <RESOURCE-GROUP> \
  --admin-username <USERNAME> \
  --admin-password <STRONG_PASSWORD> \
  --image MicrosoftWindowsServer:WindowsServer:2022-datacenter-core:latest

**Note**: For security, sensitive information such as usernames, passwords, resource group names, and VM names are represented with placeholders (e.g., `<USERNAME>`, `<STRONG_PASSWORD>`, `<RESOURCE-GROUP>`, `<VM-NAME>`). Replace these with your actual values when using the commands.

### Challenge Faced: Identifying Correct VM Image

**Problem:**  
While deploying the VM via Azure CLI, I encountered an issue selecting the correct image reference. The initial command failed because I didn’t know the exact image URN required by Azure.

**Cause:**  
Azure CLI requires precise image identifiers, and "latest" is only valid if the publisher/offer/sku are correctly specified. Azure does not provide an obvious list in the error message.

**Solution:**  
I used the following command to query available images from the Microsoft Windows Server publisher:

```bash
az vm image list --publisher MicrosoftWindowsServer --offer WindowsServer --output table

