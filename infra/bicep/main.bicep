// Main Bicep template for Azure VM + Network infrastructure
// Deployment scope: subscription (creates resource group)
targetScope = 'subscription'

// Parameters
@description('Azure region for all resources')
param location string = 'swedencentral'

@description('Name of the resource group to create')
@minLength(1)
@maxLength(90)
param resourceGroupName string = 'rg-demo-vm'

@description('Administrator username for the VM')
@minLength(1)
@maxLength(20)
param adminUsername string = 'azureuser'

@description('Administrator password for the VM')
@secure()
@minLength(12)
param adminPassword string

@description('Virtual machine size')
param vmSize string = 'Standard_B2s'

@description('Windows Server OS version')
@allowed([
  '2019-Datacenter'
  '2022-Datacenter'
])
param osVersion string = '2022-Datacenter'

@description('Prefix for naming resources')
@minLength(3)
@maxLength(10)
param resourcePrefix string = 'demo'

// Variables
var uniqueSuffix = uniqueString(subscription().subscriptionId, resourceGroupName)

// Create resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// Deploy network infrastructure
module network 'modules/network.bicep' = {
  scope: resourceGroup
  name: 'networkDeployment'
  params: {
    location: location
    resourcePrefix: resourcePrefix
    uniqueSuffix: uniqueSuffix
  }
}

// Deploy virtual machine
module virtualMachine 'modules/vm.bicep' = {
  scope: resourceGroup
  name: 'vmDeployment'
  params: {
    location: location
    resourcePrefix: resourcePrefix
    uniqueSuffix: uniqueSuffix
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    osVersion: osVersion
    subnetId: network.outputs.subnetId
    nsgId: network.outputs.nsgId
  }
}

// Outputs
@description('Resource group name')
output resourceGroupName string = resourceGroup.name

@description('Virtual machine name')
output vmName string = virtualMachine.outputs.vmName

@description('Public IP address')
output publicIpAddress string = virtualMachine.outputs.publicIpAddress

@description('Virtual network name')
output vnetName string = network.outputs.vnetName
