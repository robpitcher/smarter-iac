# Bicep IaC

This directory contains Bicep infrastructure-as-code templates for deploying Azure resources.

## Demo Windows Server VM

The main deployment creates a Windows Server VM in Sweden Central with all necessary networking resources.

### Resources Deployed

- Resource Group
- Virtual Network with default subnet (10.0.0.0/16)
- Network Security Group (allows RDP access)
- Public IP Address
- Network Interface
- Windows Server 2022 Virtual Machine (Standard_B2s_v2)
- Managed OS Disk (Standard_LRS)

### Prerequisites

- Azure CLI installed and authenticated
- Bicep CLI installed
- An Azure subscription with appropriate permissions

### Deployment Steps

1. **Login to Azure**
   ```bash
   az login
   az account set --subscription "Your-Subscription-Name-or-ID"
   ```

2. **Validate the deployment**
   ```bash
   az deployment sub validate \
     --location swedencentral \
     --template-file main.bicep \
     --parameters main.bicepparam \
     --parameters adminPassword='YourSecurePassword123!'
   ```

3. **Deploy the infrastructure**
   ```bash
   az deployment sub create \
     --location swedencentral \
     --template-file main.bicep \
     --parameters main.bicepparam \
     --parameters adminPassword='YourSecurePassword123!'
   ```

   > **Note:** Replace `YourSecurePassword123!` with a secure password that meets Azure VM password requirements:
   > - 12-123 characters long
   > - Contains characters from 3 of these categories: lowercase, uppercase, numbers, special characters

4. **Get deployment outputs**
   ```bash
   az deployment sub show \
     --name vmDeployment \
     --query properties.outputs
   ```

### Clean Up

To delete all resources:

```bash
az group delete --name rg-demo-vm --yes --no-wait
```

### Cost Considerations

- **Standard_B2s_v2**: ~$40-50/month (2 vCPU, 8GB RAM) - burstable, cost-effective
- **Standard_LRS disk**: ~$5/month for 127GB OS disk
- **Public IP**: ~$3.50/month
- **Total estimated cost**: ~$50-60/month

The B-series VMs use a CPU credit model, making them ideal for development, testing, and demo environments that don't require sustained high CPU performance.