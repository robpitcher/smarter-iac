// Network Security Group Module

@description('Azure region for resources')
param location string

@description('Name of the Network Security Group')
param nsgName string

@description('Source IP address or range for RDP access. Use * for any source (demo only), or specify CIDR (e.g., 203.0.113.0/24)')
param rdpSourceAddressPrefix string = '*'

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
          sourceAddressPrefix: rdpSourceAddressPrefix
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
