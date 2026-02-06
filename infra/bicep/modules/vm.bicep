// Virtual Machine Module - VM, NIC, Public IP, and OS Disk

@description('Azure region for all resources')
param location string

@description('Prefix for resource naming')
param resourcePrefix string

@description('Admin username for the VM')
param adminUsername string

@description('Admin password for the VM')
@secure()
param adminPassword string

@description('VM size for the virtual machine')
param vmSize string

@description('Windows Server OS version')
param windowsOSVersion string

@description('Subnet ID for the network interface')
param subnetId string

// Variables for resource naming
var vmName = '${resourcePrefix}-vm'
var nicName = '${resourcePrefix}-nic'
var publicIpName = '${resourcePrefix}-pip'
var osDiskName = '${vmName}-osdisk'

// Public IP Address
resource publicIp 'Microsoft.Network/publicIPAddresses@2024-01-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: '${resourcePrefix}-${uniqueString(resourceGroup().id)}'
    }
  }
}

// Network Interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2024-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

// Virtual Machine
resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: windowsOSVersion
        version: 'latest'
      }
      osDisk: {
        name: osDiskName
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 127
      }
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        enableAutomaticUpdates: true
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
        }
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

// Outputs
@description('Virtual machine ID')
output vmId string = virtualMachine.id

@description('Virtual machine name')
output vmName string = virtualMachine.name

@description('Network interface ID')
output nicId string = networkInterface.id

@description('Public IP address')
output publicIpAddress string = publicIp.properties.dnsSettings.fqdn
