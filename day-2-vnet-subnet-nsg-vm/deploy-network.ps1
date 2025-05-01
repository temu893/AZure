# deploy-network.ps1

# Set basic configuration
$resourceGroup = 
$location = 
$vnetName = "MyVnet"
$subnet1 = "SubnetA"
$subnet2 = "SubnetB"
$addressPrefix = "10.0.0.0/16"
$subnet1Prefix = "10.0.1.0/24"
$subnet2Prefix = "10.0.2.0/24"
$nsgName = "MyNSG"
$vmName = "MySecureVM"
$publicIPName = "$vmName-PublicIP"
$nicName = "$vmName-NIC"

# Prompt for sensitive input
$adminUsername = Read-Host "Enter admin username"
$adminPassword = Read-Host "Enter admin password" 


# Create VNet + Subnet A
az network vnet create `
  --resource-group $resourceGroup `
  --name $vnetName `
  --address-prefixes $addressPrefix `
  --subnet-name $subnet1 `
  --subnet-prefixes $subnet1Prefix

# Create Subnet B
az network vnet subnet create `
  --resource-group $resourceGroup `
  --vnet-name $vnetName `
  --name $subnet2 `
  --address-prefixes $subnet2Prefix

# Create NSG
az network nsg create `
  --resource-group $resourceGroup `
  --name $nsgName

# Associate NSG with Subnet A
az network vnet subnet update `
  --resource-group $resourceGroup `
  --vnet-name $vnetName `
  --name $subnet1 `
  --network-security-group $nsgName

# Create RDP rule (for dev/testing — restrict IP in prod!)
az network nsg rule create `
  --resource-group $resourceGroup `
  --nsg-name $nsgName `
  --name "AllowRDP" `
  --protocol Tcp `
  --direction Inbound `
  --priority 1000 `
  --source-address-prefixes "*" `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 3389 `
  --access Allow `
  --description "Allow RDP for dev access"

# Create public IP
az network public-ip create `
  --resource-group $resourceGroup `
  --name $publicIPName

# Create NIC
az network nic create `
  --resource-group $resourceGroup `
  --name $nicName `
  --vnet-name $vnetName `
  --subnet $subnet1 `
  --network-security-group $nsgName `
  --public-ip-address $publicIPName

# Deploy VM
az vm create `
  --resource-group $resourceGroup `
  --name $vmName `
  --nics $nicName `
  --image Win2019Datacenter `
  --admin-username $adminUsername `
  --admin-password $plainPassword `
  --location $location `
  --size Standard_DS1_v2
