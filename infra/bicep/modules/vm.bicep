// Virtual Machine Module

@description('Name of the virtual machine')
param vmName string

@description('Azure region for the resource')
param location string

@description('Size of the virtual machine')
param vmSize string

@description('Administrator username for the VM')
param adminUsername string

@description('Administrator password for the VM')
@secure()
param adminPassword string

@description('Resource ID of the network interface')
param nicId string

@description('Name of the OS disk')
param osDiskName string

@description('Windows Server OS version')
param windowsOSVersion string = '2022-datacenter-azure-edition'

// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
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
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
        }
      }
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
          storageAccountType: 'Standard_LRS'
        }
        caching: 'ReadWrite'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicId
        }
      ]
    }
  }
}

@description('Name of the virtual machine')
output vmName string = vm.name

@description('Resource ID of the virtual machine')
output vmId string = vm.id
