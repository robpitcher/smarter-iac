// Network Interface Module

@description('Name of the network interface')
param nicName string

@description('Azure region for the resource')
param location string

@description('Resource ID of the subnet')
param subnetId string

@description('Resource ID of the public IP address')
param publicIpId string

// Network Interface
resource nic 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpId
          }
        }
      }
    ]
  }
}

@description('Resource ID of the network interface')
output nicId string = nic.id
