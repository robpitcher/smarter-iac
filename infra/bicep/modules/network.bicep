// Network Module - Virtual Network, Subnet, and Network Security Group

@description('Azure region for all resources')
param location string

@description('Prefix for resource naming')
param resourcePrefix string

// Variables for network configuration
var vnetName = '${resourcePrefix}-vnet'
var subnetName = 'default'
var nsgName = '${resourcePrefix}-nsg'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = '10.0.0.0/24'

// Network Security Group
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          description: 'Allow RDP access for demo purposes'
        }
      }
      {
        name: 'AllowHTTPS'
        properties: {
          priority: 1100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
          description: 'Allow HTTPS access'
        }
      }
    ]
  }
}

// Virtual Network
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
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

// Outputs
@description('Virtual network ID')
output vnetId string = virtualNetwork.id

@description('Virtual network name')
output vnetName string = virtualNetwork.name

@description('Subnet ID')
output subnetId string = virtualNetwork.properties.subnets[0].id

@description('Network security group ID')
output nsgId string = networkSecurityGroup.id
