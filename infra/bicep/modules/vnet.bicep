// Virtual Network Module

@description('Name of the virtual network')
param vnetName string

@description('Azure region for the resource')
param location string

@description('Address prefix for the virtual network')
param vnetAddressPrefix string

@description('Name of the subnet')
param subnetName string

@description('Address prefix for the subnet')
param subnetAddressPrefix string

@description('Resource ID of the network security group')
param nsgId string

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          networkSecurityGroup: {
            id: nsgId
          }
        }
      }
    ]
  }
}

@description('Resource ID of the subnet')
output subnetId string = vnet.properties.subnets[0].id

@description('Name of the virtual network')
output vnetName string = vnet.name
