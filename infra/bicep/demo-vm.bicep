// Demo VM Deployment - Windows Server with Networking
targetScope = 'subscription'

@description('Name of the resource group')
param resourceGroupName string = 'rg-demo-vm'

@description('Azure region for all resources')
param location string = 'swedencentral'

@description('Name prefix for resources')
param namePrefix string = 'demo'

@description('Administrator username for the VM')
@minLength(1)
@maxLength(20)
param adminUsername string

@description('Administrator password for the VM')
@secure()
@minLength(12)
param adminPassword string

@description('Size of the virtual machine')
@allowed([
  'Standard_D2s_v3'  // 2 vCPUs, 8 GB RAM
  'Standard_D4s_v3'  // 4 vCPUs, 16 GB RAM
  'Standard_B2s'     // 2 vCPUs, 4 GB RAM (low cost)
  'Standard_B2ms'    // 2 vCPUs, 8 GB RAM (low cost)
])
param vmSize string = 'Standard_B2ms'

@description('Windows Server OS version')
@allowed([
  '2019-Datacenter'
  '2022-Datacenter'
])
param windowsOSVersion string = '2022-Datacenter'

// Create Resource Group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

// Deploy VM and networking resources within the resource group
module vmResources './modules/vm-resources.bicep' = {
  scope: resourceGroup
  name: 'vmResourcesDeployment'
  params: {
    location: location
    namePrefix: namePrefix
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    windowsOSVersion: windowsOSVersion
  }
}

// Outputs
@description('Resource Group name')
output resourceGroupName string = resourceGroup.name

@description('VM name')
output vmName string = vmResources.outputs.vmName

@description('Public IP address')
output publicIPAddress string = vmResources.outputs.publicIPAddress

@description('VM FQDN')
output vmFqdn string = vmResources.outputs.vmFqdn
