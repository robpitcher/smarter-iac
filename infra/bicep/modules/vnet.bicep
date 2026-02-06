// Virtual Network Module

@description('Azure region for resources')
param location string

@description('Name of the Virtual Network')
param vnetName string

@description('Virtual Network address prefix')
param vnetAddressPrefix string

@description('Name of the subnet')
param subnetName string

@description('Subnet address prefix')
param subnetAddressPrefix string

@description('Network Security Group resource ID')
param nsgId string

// Virtual Network with subnet
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' = {
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

output vnetId string = virtualNetwork.id
output vnetName string = virtualNetwork.name
output subnetId string = virtualNetwork.properties.subnets[0].id
output subnetName string = virtualNetwork.properties.subnets[0].name
