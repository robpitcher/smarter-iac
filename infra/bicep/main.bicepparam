// Example parameters file for demo VM deployment
// This file shows example parameter values for reference
// 
// For deployment, you have two options:
// 
// Option 1: Use this file and provide adminPassword on command line
//   az deployment sub create --parameters @main.bicepparam --parameters adminPassword='YourPassword'
//
// Option 2: Provide all parameters on command line (recommended for CI/CD)
//   az deployment sub create --parameters resourceGroupName='rg-demo' adminUsername='azureuser' adminPassword='YourPassword' ...

using './main.bicep'

param resourceGroupName = 'rg-demo-vm'
param location = 'swedencentral'
param adminUsername = 'azureuser'
// adminPassword must be provided at deployment time
param vmSize = 'Standard_B2s_v2'
param windowsOSVersion = '2022-datacenter-azure-edition'


