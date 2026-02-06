# Azure Bicep Demo - VM + Network Infrastructure

This directory contains Azure Bicep Infrastructure as Code (IaC) for deploying a Windows Server Virtual Machine with associated networking resources.

## What Gets Deployed

This Bicep template deploys the following Azure resources:

- **Resource Group**: Container for all resources
- **Virtual Network (VNet)**: Network with default address space (10.0.0.0/16)
- **Subnet**: Default subnet (10.0.0.0/24)
- **Network Security Group (NSG)**: With RDP access rule (port 3389)
- **Public IP Address**: For external VM access
- **Network Interface (NIC)**: VM network adapter
- **Virtual Machine**: Windows Server 2022 (Standard_B2s - low-cost demo size)
- **Managed OS Disk**: Standard LRS storage

**Target Region**: Sweden Central

## Prerequisites

Before deploying, ensure you have:

1. **Azure CLI** installed ([Download here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli))
2. **Bicep CLI** installed (comes with Azure CLI or [install separately](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install))
3. An active **Azure subscription**
4. Appropriate **permissions** to create resources at the subscription level

## Deployment Instructions

### Step 1: Login to Azure

```bash
az login
```

### Step 2: Set Your Subscription (if you have multiple)

```bash
az account set --subscription "Your-Subscription-Name-or-ID"
```

### Step 3: Validate the Bicep Template (Optional but Recommended)

This checks for syntax errors without deploying:

```bash
cd infra/bicep
bicep build main.bicep
```

If successful, you'll see a `main.json` file generated (this is excluded from git).

### Step 4: Validate Deployment

Run a validation to ensure the deployment will succeed:

```bash
az deployment sub validate \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='YourSecurePassword123!'
```

Replace `YourSecurePassword123!` with a strong password that meets Azure VM requirements:
- At least 12 characters
- Contains uppercase, lowercase, numbers, and special characters

### Step 5: Deploy the Infrastructure

Deploy to your Azure subscription:

```bash
az deployment sub create \
  --name demo-vm-deployment \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='YourSecurePassword123!'
```

**Deployment time**: Approximately 5-10 minutes

### Step 6: Get Deployment Outputs

After successful deployment, retrieve important information:

```bash
az deployment sub show \
  --name demo-vm-deployment \
  --query properties.outputs
```

This will show:
- Resource Group Name
- VM Name
- Virtual Network Name
- Public IP Address (once allocated)
- VM Resource ID

## Connecting to Your VM

### Using Remote Desktop Protocol (RDP)

1. Get the Public IP address from the deployment outputs or Azure Portal
2. Open Remote Desktop Connection (mstsc.exe on Windows)
3. Enter the Public IP address
4. Use the credentials:
   - **Username**: `azureadmin` (or what you specified)
   - **Password**: The password you provided during deployment

**Note**: The Public IP is dynamic (allocated when VM starts). It may change if the VM is deallocated.

## Customization

### Modifying Parameters

You can customize the deployment by editing `main.bicepparam` or providing parameters at the command line:

```bash
az deployment sub create \
  --name demo-vm-deployment \
  --location swedencentral \
  --template-file main.bicep \
  --parameters resourceGroupName='my-custom-rg' \
  --parameters adminUsername='myadmin' \
  --parameters adminPassword='MySecurePass123!' \
  --parameters vmSize='Standard_B1s'
```

### Available Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `location` | Azure region | `swedencentral` |
| `resourceGroupName` | Resource group name | `rg-demo-vm` |
| `adminUsername` | VM admin username | `azureadmin` |
| `adminPassword` | VM admin password (secure) | *(required)* |
| `vmSize` | VM size/SKU | `Standard_B2s` |
| `vnetAddressPrefix` | VNet address space | `10.0.0.0/16` |
| `subnetAddressPrefix` | Subnet address space | `10.0.0.0/24` |
| `resourcePrefix` | Resource naming prefix | `demo` |

## Clean Up Resources

To avoid incurring charges, delete the resource group and all its resources:

```bash
az group delete --name rg-demo-vm --yes --no-wait
```

## Architecture

```
┌─────────────────────────────────────────┐
│   Subscription (Sweden Central)         │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │  Resource Group (rg-demo-vm)      │ │
│  │                                   │ │
│  │  ┌────────────────────────────┐  │ │
│  │  │  Virtual Network           │  │ │
│  │  │  (10.0.0.0/16)             │  │ │
│  │  │                            │  │ │
│  │  │  ┌──────────────────────┐ │  │ │
│  │  │  │ Subnet               │ │  │ │
│  │  │  │ (10.0.0.0/24)        │ │  │ │
│  │  │  │                      │ │  │ │
│  │  │  │  ┌────────────────┐ │ │  │ │
│  │  │  │  │ Windows VM     │ │ │  │ │
│  │  │  │  │ + Managed Disk │ │ │  │ │
│  │  │  │  └────────────────┘ │ │  │ │
│  │  │  └──────────────────────┘ │  │ │
│  │  │           │                │  │ │
│  │  │       ┌───┴───┐            │  │ │
│  │  │       │  NIC  │            │  │ │
│  │  │       └───┬───┘            │  │ │
│  │  └───────────┼────────────────┘  │ │
│  │              │                    │ │
│  │  ┌───────────┴───────┐           │ │
│  │  │ Network Security  │           │ │
│  │  │ Group (RDP:3389)  │           │ │
│  │  └───────────────────┘           │ │
│  │              │                    │ │
│  │  ┌───────────┴───────┐           │ │
│  │  │  Public IP        │           │ │
│  │  │  (Dynamic)        │           │ │
│  │  └───────────────────┘           │ │
│  └───────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Security Considerations

⚠️ **Important**: This is a demo configuration with the following security considerations:

1. **Open RDP Access**: The NSG allows RDP (port 3389) from any source IP (`*`). For production:
   - Restrict source to specific IP ranges
   - Use Azure Bastion for secure VM access
   - Consider Just-In-Time (JIT) VM access

2. **Password Authentication**: Uses password authentication. For production:
   - Use SSH keys or certificate-based authentication where possible
   - Enable Azure AD authentication
   - Implement MFA (Multi-Factor Authentication)

3. **Dynamic Public IP**: The IP changes when VM is deallocated. For production:
   - Use Static IP allocation
   - Consider using Private Endpoints
   - Implement Azure VPN or ExpressRoute

## Troubleshooting

### Deployment Fails with "InvalidTemplateDeployment"

- Ensure your Azure CLI is up to date: `az upgrade`
- Verify you have sufficient permissions at the subscription level
- Check that the VM size is available in the target region

### Cannot Connect via RDP

- Verify the VM is running: `az vm get-instance-view --resource-group rg-demo-vm --name <vm-name>`
- Check NSG rules allow RDP on port 3389
- Ensure you're using the correct Public IP address
- Verify Windows Firewall on the VM isn't blocking RDP

### "VM Size Not Available" Error

Try a different VM size available in Sweden Central:
- `Standard_B1s` (smaller, cheaper)
- `Standard_D2s_v3` (better performance)

## Cost Estimation

Approximate monthly costs (as of 2026, Sweden Central region):
- VM (Standard_B2s): ~$30-40/month
- Managed Disk (Standard LRS 127GB): ~$5/month
- Public IP (Dynamic): ~$3/month
- Network bandwidth: Variable based on usage

**Total**: ~$40-50/month (approximate)

💡 **Tip**: To minimize costs, deallocate the VM when not in use:
```bash
az vm deallocate --resource-group rg-demo-vm --name <vm-name>
```

## Additional Resources

- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure VM Documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/)
- [Azure Virtual Network Documentation](https://learn.microsoft.com/en-us/azure/virtual-network/)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/)

## Support

For issues or questions:
1. Check the [Azure Bicep GitHub Issues](https://github.com/Azure/bicep/issues)
2. Review [Azure Documentation](https://learn.microsoft.com/en-us/azure/)
3. Open an issue in this repository