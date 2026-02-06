# Bicep IaC

This Bicep template creates a demo-ready Windows Server VM in Sweden Central with its own resource group, virtual network, subnet, NSG, NIC, managed OS disk, and public IP (with DNS label).

## Deploy

```bash
az deployment sub create \
  --location swedencentral \
  --template-file infra/bicep/main.bicep \
  --parameters infra/bicep/main.bicepparam
```

Update the parameter file with a strong `adminPassword` before deploying. The provided DNS label sample should be globally unique; adjust if needed.

## Validate locally

```bash
bicep build infra/bicep/main.bicep
bicep validate --parameters infra/bicep/main.bicepparam infra/bicep/main.bicep
```
