// Virtual Machine module: Windows Server VM, Public IP, NIC, and Managed Disk
targetScope = 'resourceGroup'

// Parameters
@description('Azure region for all resources')
param location string

@description('Prefix for naming resources')
param resourcePrefix string

@description('Unique suffix for resource names')
param uniqueSuffix string

@description('Administrator username for the VM')
param adminUsername string

@description('Administrator password for the VM')
@secure()
param adminPassword string

@description('Virtual machine size')
param vmSize string

@description('Windows Server OS version')
param osVersion string

@description('Subnet resource ID')
param subnetId string

@description('Network security group resource ID')
param nsgId string

// Variables
var vmName = '${resourcePrefix}-vm-${uniqueSuffix}'
var nicName = '${resourcePrefix}-nic-${uniqueSuffix}'
var publicIpName = '${resourcePrefix}-pip-${uniqueSuffix}'
var osDiskName = '${vmName}-osdisk'

// Public IP Address
resource publicIp 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: toLower('${resourcePrefix}-${uniqueSuffix}')
    }
  }
}

// Network Interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgId
    }
  }
}

// Virtual Machine
resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: osVersion
        version: 'latest'
      }
      osDisk: {
        name: osDiskName
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        caching: 'ReadWrite'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

// Outputs
@description('Virtual machine name')
output vmName string = virtualMachine.name

@description('Public IP address')
output publicIpAddress string = publicIp.properties.ipAddress

@description('Fully qualified domain name')
output fqdn string = publicIp.properties.dnsSettings.fqdn
