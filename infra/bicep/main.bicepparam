// Bicep parameter file for demo VM deployment
using 'main.bicep'

// Azure region for all resources
param location = 'swedencentral'

// Resource group name
param resourceGroupName = 'rg-demo-vm'

// VM admin username (change before deployment)
param adminUsername = 'azureadmin'

// VM admin password - REQUIRED: Provide at deployment time
// Use --parameters adminPassword='YourSecurePassword123!' or through secure method
// param adminPassword = '' // DO NOT set password in this file

// VM size - Standard_B2s is low-cost and suitable for demos
param vmSize = 'Standard_B2s'

// Network configuration - default address spaces
param vnetAddressPrefix = '10.0.0.0/16'
param subnetAddressPrefix = '10.0.0.0/24'

// Resource naming prefix
param resourcePrefix = 'demo'
