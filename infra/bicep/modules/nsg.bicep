// Network Security Group Module

@description('Azure region for resources')
param location string

@description('Name of the Network Security Group')
param nsgName string

// Network Security Group with basic RDP rule for Windows VM demo
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
    ]
  }
}

output nsgId string = networkSecurityGroup.id
output nsgName string = networkSecurityGroup.name
