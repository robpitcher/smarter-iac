targetScope = 'resourceGroup'

@description('Azure region for all resources.')
@minLength(1)
@maxLength(50)
param location string

@description('Prefix used to build resource names.')
@minLength(1)
@maxLength(90)
param namePrefix string

@description('Username for the local administrator account on the VM.')
@minLength(1)
@maxLength(20)
param adminUsername string

@description('Password for the local administrator account on the VM.')
@secure()
@minLength(14)
@maxLength(123)
param adminPassword string

@description('Size for the Windows Server virtual machine.')
@minLength(1)
param vmSize string

@description('Address prefix for the virtual network.')
param virtualNetworkAddressPrefix string

@description('Address prefix for the default subnet.')
param subnetAddressPrefix string

@description('DNS label prefix for the public IP address (must be globally unique).')
@minLength(1)
@maxLength(80)
param publicIpDnsLabel string

var virtualNetworkName = '${namePrefix}-vnet'
var subnetName = 'default'
var networkSecurityGroupName = '${namePrefix}-nsg'
var publicIpName = '${namePrefix}-pip'
var networkInterfaceName = '${namePrefix}-nic'
var virtualMachineName = '${namePrefix}-vm'

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-RDP'
        properties: {
          priority: 300
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkAddressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  name: subnetName
  parent: virtualNetwork
  properties: {
    addressPrefix: subnetAddressPrefix
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: publicIpDnsLabel
    }
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: virtualMachineName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: virtualMachineName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 127
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

output publicIpAddress string = publicIpAddress.properties.ipAddress
output publicIpFqdn string = publicIpAddress.properties.dnsSettings.fqdn
