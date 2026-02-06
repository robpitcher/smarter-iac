// Parameter file for main.bicep
// This file contains example parameter values for demo deployment
using './main.bicep'

// Azure region for resources
param location = 'swedencentral'

// Resource group name
param resourceGroupName = 'rg-demo-vm'

// VM administrator username
param adminUsername = 'azureuser'

// VM administrator password - MUST be provided at deployment time
// Use: az deployment sub create --parameters main.bicepparam --parameters adminPassword='YourSecurePassword123!'
// Or use: az deployment sub create --parameters main.bicepparam (will prompt for password)
param adminPassword = readEnvironmentVariable('ADMIN_PASSWORD', '')

// VM size - Standard_B2s is a low-cost general purpose size
param vmSize = 'Standard_B2s'

// Windows Server version
param osVersion = '2022-Datacenter'

// Resource naming prefix
param resourcePrefix = 'demo'
