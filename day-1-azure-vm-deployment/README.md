## VM Deployment with Azure CLI

In this session, I deployed a virtual machine (VM) using the Azure CLI. The command used to create the VM is:

az vm create \
  --name <VM-NAME> \
  --resource-group <RESOURCE-GROUP> \
  --admin-username <USERNAME> \
  --admin-password <STRONG_PASSWORD> \
  --image MicrosoftWindowsServer:WindowsServer:2022-datacenter-core:latest

**Note**: For security, sensitive information such as usernames, passwords, resource group names, and VM names are represented with placeholders (e.g., `<USERNAME>`, `<STRONG_PASSWORD>`, `<RESOURCE-GROUP>`, `<VM-NAME>`). Replace these with your actual values when using the commands.
### Challenge Faced
While creating the VM, I faced difficulty finding the correct image. To address this, I used the following command to list available images from the specified publisher and offer, then selected an appropriate image from the list:

az vm image list --publisher MicrosoftWindowsServer --offer WindowsServer
