VM Deployment with Azure CLI
In this session, I deployed a virtual machine (VM) using the Azure CLI. The command used to create the VM is:
az vm create --name VM-2 --resource-group TemDevOps --admin-username T**** --admin-password V****** --image MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-core:latest
Challenge Faced
While creating the VM, I faced difficulty finding the correct image. To address this, I used the following command to list available images from the specified publisher and offer, then selected an appropriate image from the list: 
az vm image list --publisher MicrosoftWindowsServer --offer WindowsServer
