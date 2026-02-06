// Azure VM + Network Demo Infrastructure
// Deploys a Windows Server VM with networking components in Sweden Central

targetScope = 'subscription'

@description('Azure region for all resources')
@minLength(3)
@maxLength(50)
param location string = 'swedencentral'

@description('Name of the resource group')
@minLength(1)
@maxLength(90)
param resourceGroupName string = 'rg-demo-vm-${uniqueString(subscription().subscriptionId)}'

@description('Admin username for the VM')
@minLength(1)
@maxLength(20)
param adminUsername string = 'azureadmin'

@description('Admin password for the VM')
@secure()
@minLength(12)
@maxLength(123)
param adminPassword string

@description('Prefix for resource naming')
@minLength(1)
@maxLength(10)
param resourcePrefix string = 'demo'

@description('VM size for the virtual machine')
param vmSize string = 'Standard_B2s'

@description('Windows Server OS version')
@allowed([
  '2019-datacenter-gensecond'
  '2022-datacenter-g2'
  '2022-datacenter-azure-edition'
])
param windowsOSVersion string = '2022-datacenter-g2'

// Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// Virtual Network module
module virtualNetwork 'modules/network.bicep' = {
  scope: resourceGroup
  name: 'virtualNetworkDeployment'
  params: {
    location: location
    resourcePrefix: resourcePrefix
  }
}

// Virtual Machine module
module virtualMachine 'modules/vm.bicep' = {
  scope: resourceGroup
  name: 'virtualMachineDeployment'
  params: {
    location: location
    resourcePrefix: resourcePrefix
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    windowsOSVersion: windowsOSVersion
    subnetId: virtualNetwork.outputs.subnetId
  }
}

// Outputs
@description('Resource group name')
output resourceGroupName string = resourceGroup.name

@description('VM name')
output vmName string = virtualMachine.outputs.vmName

@description('Public IP address')
output publicIpAddress string = virtualMachine.outputs.publicIpAddress

@description('Virtual network name')
output vnetName string = virtualNetwork.outputs.vnetName
