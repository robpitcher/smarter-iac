// Demo Azure VM + Network Infrastructure
// Creates a Windows Server VM with associated networking resources in Sweden Central

targetScope = 'subscription'

// Parameters
@description('Name of the resource group to create')
@minLength(1)
@maxLength(90)
param resourceGroupName string = 'rg-demo-vm'

@description('Azure region for all resources')
param location string = 'swedencentral'

@description('Administrator username for the VM')
@minLength(1)
@maxLength(20)
param adminUsername string

@description('Administrator password for the VM')
@secure()
@minLength(12)
param adminPassword string

@description('Size of the virtual machine')
param vmSize string = 'Standard_B2s'

@description('Name prefix for resources')
@minLength(1)
@maxLength(10)
param namePrefix string = 'demo'

// Variables
var uniqueSuffix = uniqueString(subscription().subscriptionId, resourceGroupName)
var vnetName = '${namePrefix}-vnet-${uniqueSuffix}'
var subnetName = 'default'
var nsgName = '${namePrefix}-nsg-${uniqueSuffix}'
var publicIpName = '${namePrefix}-pip-${uniqueSuffix}'
var nicName = '${namePrefix}-nic-${uniqueSuffix}'
var vmName = '${namePrefix}-vm-${uniqueSuffix}'
var osDiskName = '${vmName}-osdisk'

// Address spaces
var vnetAddressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = '10.0.1.0/24'

// Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// Network Security Group
module nsg 'modules/nsg.bicep' = {
  name: 'nsgDeployment'
  scope: resourceGroup
  params: {
    nsgName: nsgName
    location: location
  }
}

// Virtual Network
module vnet 'modules/vnet.bicep' = {
  name: 'vnetDeployment'
  scope: resourceGroup
  params: {
    vnetName: vnetName
    location: location
    vnetAddressPrefix: vnetAddressPrefix
    subnetName: subnetName
    subnetAddressPrefix: subnetAddressPrefix
    nsgId: nsg.outputs.nsgId
  }
}

// Public IP
module publicIp 'modules/publicip.bicep' = {
  name: 'publicIpDeployment'
  scope: resourceGroup
  params: {
    publicIpName: publicIpName
    location: location
  }
}

// Network Interface
module nic 'modules/nic.bicep' = {
  name: 'nicDeployment'
  scope: resourceGroup
  params: {
    nicName: nicName
    location: location
    subnetId: vnet.outputs.subnetId
    publicIpId: publicIp.outputs.publicIpId
  }
}

// Virtual Machine
module vm 'modules/vm.bicep' = {
  name: 'vmDeployment'
  scope: resourceGroup
  params: {
    vmName: vmName
    location: location
    vmSize: vmSize
    adminUsername: adminUsername
    adminPassword: adminPassword
    nicId: nic.outputs.nicId
    osDiskName: osDiskName
  }
}

// Outputs
@description('Resource group name')
output resourceGroupName string = resourceGroup.name

@description('Virtual machine name')
output vmName string = vm.outputs.vmName

@description('Public IP address')
output publicIpAddress string = publicIp.outputs.publicIpAddress

@description('Virtual network name')
output vnetName string = vnet.outputs.vnetName
