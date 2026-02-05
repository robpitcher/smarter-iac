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
- Bicep CLI installed (included with Azure CLI)
- An Azure subscription with appropriate permissions

### Deployment Steps

1. **Login to Azure**
   ```bash
   az login
   az account set --subscription "Your-Subscription-Name-or-ID"
   ```

2. **Validate the deployment** (optional but recommended)
   
   Using inline parameters (recommended):
   ```bash
   az deployment sub validate \
     --location swedencentral \
     --template-file main.bicep \
     --parameters resourceGroupName='rg-demo-vm' \
       location='swedencentral' \
       adminUsername='azureuser' \
       adminPassword='YourSecurePassword123!' \
       vmSize='Standard_B2s_v2' \
       windowsOSVersion='2022-datacenter-azure-edition'
   ```

3. **Deploy the infrastructure**
   
   Using inline parameters (recommended):
   ```bash
   az deployment sub create \
     --name demo-vm-deployment \
     --location swedencentral \
     --template-file main.bicep \
     --parameters resourceGroupName='rg-demo-vm' \
       location='swedencentral' \
       adminUsername='azureuser' \
       adminPassword='YourSecurePassword123!' \
       vmSize='Standard_B2s_v2' \
       windowsOSVersion='2022-datacenter-azure-edition'
   ```

   Or using a parameters file with password override:
   ```bash
   az deployment sub create \
     --name demo-vm-deployment \
     --location swedencentral \
     --template-file main.bicep \
     --parameters @main.bicepparam \
     --parameters adminPassword='YourSecurePassword123!'
   ```

   > **Password Requirements:**
   > - 12-123 characters long
   > - Contains characters from 3 of these categories: lowercase, uppercase, numbers, special characters
   > - Cannot contain username

4. **Get deployment outputs**
   ```bash
   # Get all outputs
   az deployment sub show \
     --name demo-vm-deployment \
     --query properties.outputs
   
   # Get just the public IP
   az deployment sub show \
     --name demo-vm-deployment \
     --query properties.outputs.publicIPAddress.value -o tsv
   ```

5. **Connect to the VM**
   
   Use Remote Desktop Protocol (RDP) with:
   - **Host**: Output from `publicIPAddress`
   - **Username**: Output from `adminUsername` (default: azureuser)
   - **Password**: The password you provided during deployment

### Clean Up

To delete all resources:

```bash
az group delete --name rg-demo-vm --yes --no-wait
```

### Cost Considerations

- **Standard_B2s_v2**: ~$40-50/month (2 vCPU, 8GB RAM) - burstable, cost-effective
- **Standard_LRS disk**: ~$5/month for 127GB OS disk
- **Public IP**: ~$3.50/month
- **Total estimated cost**: ~$50-60/month (approximately $0.07/hour)

The B-series VMs use a CPU credit model, making them ideal for development, testing, and demo environments that don't require sustained high CPU performance.

### Customization

You can customize the deployment by modifying parameters:

- `resourceGroupName`: Name of the resource group to create
- `location`: Azure region (default: swedencentral)
- `adminUsername`: VM administrator username
- `vmSize`: VM size (see [Azure VM sizes](https://learn.microsoft.com/azure/virtual-machines/sizes))
- `windowsOSVersion`: Windows Server SKU (2019-datacenter-gensecond, 2022-datacenter-azure-edition, 2022-datacenter-g2)

### Security Notes

- The NSG allows RDP access from any source IP (`*`). For production, restrict to specific IP ranges.
- Use Azure Key Vault or environment variables for sensitive parameters in CI/CD pipelines.
- Enable Azure Backup and Security Center for production workloads.