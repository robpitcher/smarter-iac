# Bicep IaC

This folder contains Azure Bicep Infrastructure as Code (IaC) templates for deploying Azure resources.

## Current Infrastructure

### Azure VM + Network Demo
A complete Windows Server virtual machine deployment with networking components:
- **Windows Server 2022** virtual machine (Standard_B2s)
- **Virtual Network** with default subnet (10.0.0.0/16)
- **Network Security Group** with RDP and HTTPS rules
- **Public IP address** for remote access
- **Network Interface**
- **Managed OS Disk** (StandardSSD_LRS)

**Location:** Sweden Central

## Prerequisites

- Azure CLI installed (`az --version`)
- Bicep CLI installed (`bicep --version`)
- Azure subscription with appropriate permissions
- Authenticated to Azure (`az login`)

## Deployment Instructions

### 1. Set your Azure subscription (if needed)

```bash
az account list --output table
az account set --subscription "<subscription-id-or-name>"
```

### 2. Deploy using Bicep parameter file

The deployment requires an admin password which must be provided securely at deployment time.

```bash
# Deploy at subscription scope
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='<YourSecurePassword123!>'
```

**Note:** Replace `<YourSecurePassword123!>` with a strong password that meets Azure VM requirements:
- At least 12 characters
- Mix of uppercase, lowercase, numbers, and special characters

### 3. Alternative: Deploy with inline parameters

```bash
az deployment sub create \
  --location swedencentral \
  --template-file main.bicep \
  --parameters location='swedencentral' \
               resourceGroupName='rg-demo-vm' \
               adminUsername='azureadmin' \
               adminPassword='<YourSecurePassword123!>' \
               resourcePrefix='demo' \
               vmSize='Standard_B2s' \
               windowsOSVersion='2022-datacenter-g2'
```

### 4. Verify deployment

After deployment completes, you can verify the resources:

```bash
# List resource groups
az group list --query "[?starts_with(name, 'rg-demo-vm')]" --output table

# Show VM details
az vm show --resource-group <resource-group-name> --name demo-vm --output table

# Get public IP address
az vm list-ip-addresses --resource-group <resource-group-name> --name demo-vm --output table
```

## Validation and Linting

### Validate Bicep syntax

```bash
# Validate main template
bicep build main.bicep

# Validate modules
bicep build modules/network.bicep
bicep build modules/vm.bicep
```

### Validate deployment (What-If)

```bash
az deployment sub what-if \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='<YourSecurePassword123!>'
```

### Validate deployment (pre-flight)

```bash
az deployment sub validate \
  --location swedencentral \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --parameters adminPassword='<YourSecurePassword123!>'
```

## Connecting to the VM

Once deployed, you can connect to the Windows Server VM using Remote Desktop Protocol (RDP):

1. Get the public IP or FQDN from deployment outputs
2. Open Remote Desktop Connection (mstsc)
3. Enter the FQDN or public IP address
4. Use the admin credentials you specified during deployment

## Clean Up

To delete all resources when finished:

```bash
# Delete the resource group (removes all contained resources)
az group delete --name <resource-group-name> --yes --no-wait
```

## Security Considerations

- The NSG allows RDP access from any source IP for demo purposes
- In production, restrict RDP access to specific IP ranges
- Use Azure Bastion for more secure VM access
- Store passwords in Azure Key Vault instead of command-line parameters
- Enable Azure Security Center recommendations

## Cost Optimization

- The `Standard_B2s` VM size is cost-effective for demos and testing
- Remember to delete resources when not in use to avoid unnecessary charges
- Consider using Azure Cost Management to monitor spending

## Troubleshooting

### Deployment fails with "InvalidTemplateDeployment"
- Check that you're deploying at the correct scope (subscription)
- Verify all required parameters are provided
- Review error messages in the deployment operation details

### Cannot connect to VM via RDP
- Verify NSG rules allow inbound traffic on port 3389
- Check that the VM is running: `az vm get-instance-view`
- Confirm public IP is assigned and reachable

### Password doesn't meet requirements
- Ensure password is 12-123 characters
- Include uppercase, lowercase, numbers, and special characters
- Avoid common patterns or dictionary words
