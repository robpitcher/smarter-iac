// Parameter file for Azure VM + Network Demo Infrastructure
using './main.bicep'

// Azure region - Sweden Central
param location = 'swedencentral'

// Resource group name (will include unique suffix)
param resourceGroupName = 'rg-demo-vm'

// VM admin credentials
// Note: The password must be provided at deployment time via command line or Key Vault
// Example: az deployment sub create --parameters adminPassword='YourSecurePassword123!'
param adminUsername = 'azureadmin'

// Resource naming prefix
param resourcePrefix = 'demo'

// VM configuration
param vmSize = 'Standard_B2s'
param windowsOSVersion = '2022-datacenter-g2'
