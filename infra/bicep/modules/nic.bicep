// Network Interface Module

@description('Azure region for resources')
param location string

@description('Name of the Network Interface')
param nicName string

@description('Subnet resource ID')
param subnetId string

@description('Public IP resource ID')
param publicIpId string

// Network Interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIpId
          }
        }
      }
    ]
  }
}

output nicId string = networkInterface.id
output nicName string = networkInterface.name
