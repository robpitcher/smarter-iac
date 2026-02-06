// Demo Azure VM + Network Infrastructure
// Deploys a Windows Server VM with networking resources

targetScope = 'subscription'

// Parameters
@description('Azure region for all resources')
param location string = 'swedencentral'

@description('Name of the resource group')
@minLength(1)
@maxLength(90)
param resourceGroupName string = 'rg-demo-vm'

@description('Admin username for the VM')
@minLength(1)
@maxLength(20)
param adminUsername string = 'azureadmin'

@description('Admin password for the VM')
@secure()
@minLength(12)
param adminPassword string

@description('VM size for the demo')
param vmSize string = 'Standard_B2s'

@description('Virtual network address prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Subnet address prefix')
param subnetAddressPrefix string = '10.0.0.0/24'

@description('Prefix for resource naming')
@minLength(1)
@maxLength(10)
param resourcePrefix string = 'demo'

// Variables
var uniqueSuffix = uniqueString(subscription().subscriptionId, location, resourceGroupName)
var vmName = '${resourcePrefix}-vm-${uniqueSuffix}'
var vnetName = '${resourcePrefix}-vnet-${uniqueSuffix}'
var subnetName = 'default'
var nsgName = '${resourcePrefix}-nsg-${uniqueSuffix}'
var nicName = '${resourcePrefix}-nic-${uniqueSuffix}'
var publicIpName = '${resourcePrefix}-pip-${uniqueSuffix}'

// Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// Network Security Group
module nsg 'modules/nsg.bicep' = {
  scope: resourceGroup
  name: 'nsgDeployment'
  params: {
    location: location
    nsgName: nsgName
  }
}

// Virtual Network
module vnet 'modules/vnet.bicep' = {
  scope: resourceGroup
  name: 'vnetDeployment'
  params: {
    location: location
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    subnetName: subnetName
    subnetAddressPrefix: subnetAddressPrefix
    nsgId: nsg.outputs.nsgId
  }
}

// Public IP
module publicIp 'modules/publicip.bicep' = {
  scope: resourceGroup
  name: 'publicIpDeployment'
  params: {
    location: location
    publicIpName: publicIpName
  }
}

// Network Interface
module nic 'modules/nic.bicep' = {
  scope: resourceGroup
  name: 'nicDeployment'
  params: {
    location: location
    nicName: nicName
    subnetId: vnet.outputs.subnetId
    publicIpId: publicIp.outputs.publicIpId
  }
}

// Virtual Machine
module vm 'modules/vm.bicep' = {
  scope: resourceGroup
  name: 'vmDeployment'
  params: {
    location: location
    vmName: vmName
    vmSize: vmSize
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicId: nic.outputs.nicId
  }
}

// Outputs (no secrets)
output resourceGroupName string = resourceGroup.name
output vmName string = vmName
output vnetName string = vnetName
output publicIpAddress string = publicIp.outputs.publicIpAddress
output vmId string = vm.outputs.vmId
