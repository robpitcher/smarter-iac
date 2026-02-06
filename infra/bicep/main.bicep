targetScope = 'subscription'

@description('Name of the resource group to create for the demo.')
@minLength(1)
@maxLength(90)
param resourceGroupName string = 'demo-swe-rg'

@description('Azure region for all resources.')
@minLength(1)
@maxLength(50)
param location string = 'swedencentral'

@description('Username for the local administrator account on the VM.')
@minLength(1)
@maxLength(20)
param adminUsername string = 'azureuser'

@description('Password for the local administrator account on the VM.')
@secure()
@minLength(14)
@maxLength(123)
param adminPassword string

@description('Size for the Windows Server virtual machine.')
@minLength(1)
param vmSize string = 'Standard_B2s'

@description('Address prefix for the virtual network.')
param virtualNetworkAddressPrefix string = '10.0.0.0/16'

@description('Address prefix for the default subnet.')
param subnetAddressPrefix string = '10.0.0.0/24'

@description('DNS label prefix for the public IP address (must be globally unique).')
@minLength(1)
@maxLength(80)
param publicIpDnsLabel string = toLower('vmdemo${uniqueString(subscription().id, resourceGroupName)}')

resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

module vmStack './modules/vmStack.bicep' = {
  name: 'vmStack'
  scope: resourceGroup
  params: {
    location: location
    namePrefix: resourceGroupName
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    virtualNetworkAddressPrefix: virtualNetworkAddressPrefix
    subnetAddressPrefix: subnetAddressPrefix
    publicIpDnsLabel: publicIpDnsLabel
  }
}

output createdResourceGroupName string = resourceGroup.name
output publicIpAddress string = vmStack.outputs.publicIpAddress
output publicIpFqdn string = vmStack.outputs.publicIpFqdn
