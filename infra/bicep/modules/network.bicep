// Network module: Virtual Network, Subnet, and Network Security Group
targetScope = 'resourceGroup'

// Parameters
@description('Azure region for all resources')
param location string

@description('Prefix for naming resources')
param resourcePrefix string

@description('Unique suffix for resource names')
param uniqueSuffix string

// Variables
var vnetName = '${resourcePrefix}-vnet-${uniqueSuffix}'
var subnetName = 'default'
var nsgName = '${resourcePrefix}-nsg-${uniqueSuffix}'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetAddressPrefix = '10.0.0.0/24'

// Network Security Group with default rules
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          description: 'Allow RDP traffic (demo only - restrict source in production)'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTP'
        properties: {
          description: 'Allow HTTP traffic (demo only)'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1001
          direction: 'Inbound'
        }
      }
      {
        name: 'AllowHTTPS'
        properties: {
          description: 'Allow HTTPS traffic (demo only)'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1002
          direction: 'Inbound'
        }
      }
    ]
  }
}

// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
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
@description('Virtual network name')
output vnetName string = virtualNetwork.name

@description('Subnet resource ID')
output subnetId string = virtualNetwork.properties.subnets[0].id

@description('Network security group resource ID')
output nsgId string = networkSecurityGroup.id
