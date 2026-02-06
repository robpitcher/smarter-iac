targetScope = 'subscription'

@description('Name of the resource group to create for the demo VM.')
@minLength(1)
param resourceGroupName string

@description('Azure region for all resources.')
param location string = 'swedencentral'

@description('Admin username for the virtual machine.')
@minLength(1)
param adminUsername string = 'azureuser'

@description('Admin password for the virtual machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Size of the virtual machine.')
param vmSize string = 'Standard_B2s'

@description('Windows Server image SKU.')
param windowsSku string = '2022-datacenter-azure-edition'

@description('Address space for the virtual network.')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Address space for the subnet.')
param subnetAddressPrefix string = '10.0.0.0/24'

resource demoRg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

module vmStack 'modules/vmStack.bicep' = {
  name: 'vmStack'
  scope: demoRg
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    windowsSku: windowsSku
    vnetAddressPrefix: vnetAddressPrefix
    subnetAddressPrefix: subnetAddressPrefix
  }
}

output resourceGroup string = demoRg.name
output virtualMachineName string = vmStack.outputs.virtualMachineName
output publicIpAddress string = vmStack.outputs.publicIpAddress
