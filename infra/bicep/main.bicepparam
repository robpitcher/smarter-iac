using './main.bicep'

// Parameters for demo deployment
// Note: This file contains example values. Do not commit actual secrets.

param resourceGroupName = 'rg-demo-vm-001'
param location = 'swedencentral'
param adminUsername = 'demoadmin'
// adminPassword must be provided at deployment time using --parameters or via prompt
// It should be minimum 12 characters with complexity requirements
param vmSize = 'Standard_B2s'
param namePrefix = 'demo'
