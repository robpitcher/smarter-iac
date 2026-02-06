// Public IP Module

@description('Name of the public IP address')
param publicIpName string

@description('Azure region for the resource')
param location string

@description('SKU of the public IP address')
param publicIpSku string = 'Standard'

@description('Allocation method for the public IP')
param allocationMethod string = 'Static'

// Public IP Address
resource publicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: allocationMethod
    publicIPAddressVersion: 'IPv4'
  }
}

@description('Resource ID of the public IP address')
output publicIpId string = publicIp.id

@description('Public IP address value')
output publicIpAddress string = publicIp.properties.ipAddress
