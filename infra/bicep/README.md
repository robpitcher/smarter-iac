# Bicep IaC

This folder contains Azure Bicep Infrastructure as Code (IaC) templates for deploying demo infrastructure.

## Prerequisites

- Azure CLI (version 2.20.0 or later)
- Bicep CLI (version 0.4.0 or later)
- An active Azure subscription
- Authenticated Azure CLI session (`az login`)

## What's Deployed

The `main.bicep` template deploys the following Azure resources:

- **Resource Group** - Container for all resources
- **Virtual Network** - Network with default address space (10.0.0.0/16)
- **Subnet** - Default subnet (10.0.1.0/24)
- **Network Security Group (NSG)** - With default rules for RDP (port 3389) and HTTPS (port 443)
- **Public IP Address** - For external access to the VM
- **Network Interface** - Connects the VM to the virtual network
- **Windows Server VM** - Standard_B2s size running Windows Server 2022

## Deployment Instructions

### 1. Validate the Bicep Template

Before deploying, validate the template syntax:

```bash
cd infra/bicep
bicep build main.bicep
```

### 2. Deploy Using Azure CLI

#### Option A: Deploy with Parameter File (Recommended)

```bash
# Deploy to your subscription
az deployment sub create \
  --name demo-vm-deployment \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='<YourSecurePassword>'
```

#### Option B: Deploy with Inline Parameters

```bash
az deployment sub create \
  --name demo-vm-deployment \
  --location swedencentral \
  --template-file main.bicep \
  --parameters resourceGroupName='rg-demo-vm-001' \
  --parameters location='swedencentral' \
  --parameters adminUsername='demoadmin' \
  --parameters adminPassword='<YourSecurePassword>' \
  --parameters vmSize='Standard_B2s' \
  --parameters namePrefix='demo'
```

#### Option C: Interactive Deployment (Prompts for Password)

```bash
az deployment sub create \
  --name demo-vm-deployment \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam
```

**Note:** The admin password must meet Azure's complexity requirements:
- Minimum 12 characters
- Contains characters from at least 3 of: uppercase, lowercase, numbers, special characters

### 3. Preview Changes (What-If)

To preview what resources will be created without actually deploying:

```bash
az deployment sub what-if \
  --name demo-vm-deployment \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='<YourSecurePassword>'
```

### 4. View Deployment Outputs

After successful deployment, view the outputs:

```bash
az deployment sub show \
  --name demo-vm-deployment \
  --query properties.outputs
```

The outputs include:
- Resource group name
- Virtual machine name
- Public IP address
- Virtual network name

## Connecting to the VM

Once deployed, you can connect to the Windows Server VM via Remote Desktop Protocol (RDP):

1. Get the public IP address from deployment outputs
2. Open Remote Desktop Connection
3. Enter the public IP address
4. Use the admin username and password you provided during deployment

**Security Note:** For production environments, consider:
- Restricting NSG rules to specific IP addresses
- Using Azure Bastion for secure RDP access
- Implementing Just-In-Time (JIT) VM access

## Clean Up Resources

To delete all deployed resources:

```bash
az group delete --name rg-demo-vm-001 --yes --no-wait
```

## File Structure

```
bicep/
├── main.bicep              # Main deployment file (subscription scope)
├── main.bicepparam         # Parameter file with example values
├── modules/
│   ├── nsg.bicep          # Network Security Group module
│   ├── vnet.bicep         # Virtual Network module
│   ├── publicip.bicep     # Public IP module
│   ├── nic.bicep          # Network Interface module
│   └── vm.bicep           # Virtual Machine module
└── README.md              # This file
```

## Cost Considerations

This demo uses the following low-cost resources:
- **VM Size:** Standard_B2s (burstable, cost-effective for demos)
- **OS Disk:** Standard_LRS (locally redundant storage)
- **Public IP:** Standard SKU (required for VMs)

**Estimated cost:** Approximately $30-40 USD/month when running continuously. Stop the VM when not in use to reduce costs.

## Troubleshooting

### Validation Errors

If you encounter validation errors, ensure:
- You're authenticated to Azure (`az login`)
- Your subscription has sufficient quota
- The location 'swedencentral' is available in your subscription

### Deployment Failures

Check deployment logs:
```bash
az deployment sub show --name demo-vm-deployment
```

## Customization

To customize the deployment, modify parameters in `main.bicepparam` or override them during deployment:

- Change the VM size for more/less performance
- Modify the name prefix for different naming
- Adjust NSG rules for different access requirements
- Change the Windows Server version in the VM module