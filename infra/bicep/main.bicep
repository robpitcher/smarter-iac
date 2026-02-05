// Demo Azure VM Deployment with Windows Server
// Deploys a Windows Server VM in Sweden Central with associated networking resources

targetScope = 'subscription'

@description('The name of the resource group to create')
@minLength(1)
@maxLength(90)
param resourceGroupName string = 'rg-demo-vm'

@description('The Azure region for all resources')
param location string = 'swedencentral'

@description('Administrator username for the VM')
@minLength(1)
@maxLength(20)
param adminUsername string = 'azureuser'

@description('Administrator password for the VM')
@secure()
param adminPassword string

@description('The size of the virtual machine')
param vmSize string = 'Standard_B2s_v2'

@description('Windows Server OS version')
@allowed([
  '2019-datacenter-gensecond'
  '2022-datacenter-azure-edition'
  '2022-datacenter-g2'
])
param windowsOSVersion string = '2022-datacenter-azure-edition'

// Create resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
}

// Deploy resources into the resource group
module vmDeployment 'modules/vm.bicep' = {
  name: 'vmDeployment'
  scope: resourceGroup
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    windowsOSVersion: windowsOSVersion
  }
}

// Outputs
output resourceGroupName string = resourceGroup.name
output vmName string = vmDeployment.outputs.vmName
output publicIPAddress string = vmDeployment.outputs.publicIPAddress
output adminUsername string = adminUsername
