using './main.bicep'

param resourceGroupName = 'demo-swe-rg'
param location = 'swedencentral'
param adminUsername = 'azureuser'
@secure()
param adminPassword = 'ReplaceWithStrongP@ssw0rd!'
param vmSize = 'Standard_B2s'
param virtualNetworkAddressPrefix = '10.0.0.0/16'
param subnetAddressPrefix = '10.0.0.0/24'
param publicIpDnsLabel = toLower('vmdemo-${uniqueString(subscription().id)}')
