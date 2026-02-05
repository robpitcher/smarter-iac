using './demo-vm.bicep'

// Resource Group Configuration
param resourceGroupName = 'rg-demo-vm'
param location = 'swedencentral'
param namePrefix = 'demo'

// VM Configuration
param adminUsername = 'adminUser'
// Note: adminPassword must be provided at deployment time via --parameters or secure input
// Example: az deployment sub create ... --parameters adminPassword='YourSecurePassword123!'

param vmSize = 'Standard_B2ms' // 2 vCPUs, 8 GB RAM - low cost for demo
param windowsOSVersion = '2022-Datacenter'
