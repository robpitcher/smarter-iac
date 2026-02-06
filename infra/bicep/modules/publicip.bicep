// Public IP Module

@description('Azure region for resources')
param location string

@description('Name of the Public IP')
param publicIpName string

// Public IP for VM access
resource publicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

output publicIpId string = publicIp.id
output publicIpName string = publicIp.name
output publicIpAddress string = publicIp.properties.ipAddress
