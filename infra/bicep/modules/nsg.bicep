// Network Security Group Module

@description('Name of the network security group')
param nsgName string

@description('Azure region for the resource')
param location string

// Network Security Group with default rules for Windows Server
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-01-01' = {
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
          priority: 1010
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

@description('Resource ID of the network security group')
output nsgId string = nsg.id
