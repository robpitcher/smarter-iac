// Parameters file for demo VM deployment
// Note: adminPassword must be provided at deployment time using --parameters flag

using './main.bicep'

param resourceGroupName = 'rg-demo-vm'
param location = 'swedencentral'
param adminUsername = 'azureuser'
// adminPassword is a secure parameter and must be passed at deployment time:
// Example: az deployment sub create --parameters adminPassword='YourSecurePassword123!'
param vmSize = 'Standard_B2s_v2'
param windowsOSVersion = '2022-datacenter-azure-edition'
