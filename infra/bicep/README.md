# Bicep IaC - Azure VM + Network

This directory contains Azure Bicep Infrastructure as Code (IaC) for deploying a demo Windows Server virtual machine with associated networking resources in Azure.

## What's Deployed

The infrastructure includes:

- **Resource Group**: Container for all Azure resources
- **Virtual Network (VNet)**: 10.0.0.0/16 address space
- **Subnet**: 10.0.0.0/24 address space (default subnet)
- **Network Security Group (NSG)**: With inbound rules for RDP (3389), HTTP (80), and HTTPS (443)
- **Public IP Address**: Static IP with DNS name for accessing the VM
- **Network Interface (NIC)**: Connects the VM to the VNet and public IP
- **Virtual Machine**: Windows Server 2022 Datacenter
- **Managed OS Disk**: StandardSSD_LRS for the OS disk

All resources are deployed to **Sweden Central** region by default.

## Prerequisites

Before deploying, ensure you have:

1. **Azure CLI** installed and authenticated
   ```bash
   az login
   az account show  # Verify you're in the correct subscription
   ```

2. **Bicep CLI** installed (included with Azure CLI 2.20.0+)
   ```bash
   bicep --version
   ```

3. **Azure Subscription** with appropriate permissions (Contributor or Owner role at subscription level)

## File Structure

```
infra/bicep/
├── main.bicep              # Main template (subscription scope)
├── main.bicepparam         # Parameter file with example values
├── modules/
│   ├── network.bicep       # Network infrastructure (VNet, Subnet, NSG)
│   └── vm.bicep            # Virtual machine resources (VM, NIC, Public IP)
└── README.md               # This file
```

## Deployment

### Option 1: Deploy with Parameter File

The easiest way to deploy is using the parameter file. You'll need to provide the admin password:

```bash
# Navigate to the bicep directory
cd infra/bicep

# Deploy (will prompt for adminPassword)
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam

# Or provide password inline (for automation)
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='YourSecurePassword123!'
```

### Option 2: Deploy with Individual Parameters

You can override any parameters at deployment time:

```bash
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters resourceGroupName='rg-my-demo' \
  --parameters adminUsername='myadmin' \
  --parameters adminPassword='MySecurePassword123!' \
  --parameters resourcePrefix='myvm'
```

### Option 3: Deploy with What-If (Preview Changes)

Preview what resources will be created before deploying:

```bash
az deployment sub what-if \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='YourSecurePassword123!'
```

## Validation

### Local Validation (Fast)

Validate Bicep syntax and compile to ARM template:

```bash
# Validate main template
bicep build main.bicep

# Validate network module
bicep build modules/network.bicep

# Validate VM module
bicep build modules/vm.bicep
```

### Azure Validation (Comprehensive)

Validate against Azure APIs (checks permissions, quotas, API versions):

```bash
az deployment sub validate \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='YourSecurePassword123!'
```

## Connecting to Your VM

After deployment completes, you'll receive outputs including the public IP address:

1. **Get deployment outputs:**
   ```bash
   az deployment sub show \
     --name main \
     --query properties.outputs
   ```

2. **Connect via RDP:**
   - Open Remote Desktop Connection (mstsc.exe on Windows)
   - Enter the public IP address or FQDN
   - Login with the credentials you provided during deployment

## Customization

You can customize the deployment by modifying parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `location` | `swedencentral` | Azure region for resources |
| `resourceGroupName` | `rg-demo-vm` | Name of the resource group |
| `adminUsername` | `azureuser` | VM administrator username |
| `adminPassword` | *(required)* | VM administrator password (min 12 chars) |
| `vmSize` | `Standard_B2s` | VM size (2 vCPU, 4 GB RAM) |
| `osVersion` | `2022-Datacenter` | Windows Server version (2019 or 2022) |
| `resourcePrefix` | `demo` | Prefix for resource naming |

## Clean Up

To delete all deployed resources:

```bash
# Delete the resource group (deletes all resources within it)
az group delete --name rg-demo-vm --yes --no-wait
```

## Cost Considerations

This demo configuration uses low-cost resources:

- **VM Size**: Standard_B2s (burstable B-series, ~$30-40/month)
- **OS Disk**: StandardSSD_LRS (128 GB, ~$5/month)
- **Public IP**: Standard SKU Static (~$3/month)
- **Networking**: VNet and NSG have no additional cost

**Total estimated cost**: ~$40-50 USD/month when running continuously.

To minimize costs:
- Stop (deallocate) the VM when not in use: `az vm deallocate --resource-group rg-demo-vm --name <vm-name>`
- Delete resources when no longer needed

## Security Notes

⚠️ **This is a demo configuration**. For production use:

1. **Restrict NSG rules**: Don't allow RDP from `*` (any source). Limit to your IP address or corporate network.
2. **Use Azure Bastion**: Instead of exposing RDP publicly, use Azure Bastion for secure access.
3. **Enable JIT Access**: Use Azure Security Center's Just-In-Time VM access.
4. **Key-based authentication**: Consider using Azure Key Vault for secrets management.
5. **Monitoring**: Enable Azure Monitor and diagnostic settings.
6. **Backup**: Configure Azure Backup for production VMs.

## Troubleshooting

### Bicep Build Errors

```bash
# Check Bicep version
bicep --version

# Upgrade Bicep
az bicep upgrade

# Validate specific file
bicep build <file>.bicep
```

### Deployment Errors

```bash
# View deployment logs
az deployment sub show --name main

# List all subscription deployments
az deployment sub list --output table
```

### Common Issues

1. **Password complexity**: Ensure password meets Azure requirements (min 12 chars, includes uppercase, lowercase, number, special char)
2. **Quota limits**: Check your subscription quotas for the selected VM size and region
3. **Permissions**: Ensure you have Contributor or Owner role at subscription level

## Additional Resources

- [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Azure VM Sizes](https://learn.microsoft.com/azure/virtual-machines/sizes)
- [Azure Naming Conventions](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
