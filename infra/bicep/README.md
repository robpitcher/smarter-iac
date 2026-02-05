# Bicep IaC

## Demo VM Deployment

This directory contains Bicep templates for deploying a demo Windows Server VM in Azure with associated networking resources.

### Resources Created

- Resource Group
- Virtual Network with default subnet (10.0.0.0/16)
- Network Security Group (NSG) with RDP access
- Public IP address with DNS label
- Network Interface
- Windows Server Virtual Machine (2-4 vCPUs)
- Managed OS disk

### Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- Azure subscription with appropriate permissions
- Authenticated to Azure (`az login`)

### Deployment Instructions

#### Security Note

⚠️ **Important Security Considerations:**
- The default NSG configuration allows RDP access from any IP address (`*`). For production use, restrict the `sourceAddressPrefix` to specific IP ranges or consider using Azure Bastion for secure access.
- Avoid passing passwords via command-line as they may be exposed in shell history. Use one of the secure methods below.

#### Secure Password Input Methods

**Recommended: Read password securely from prompt**
```bash
read -sp "Enter admin password: " ADMIN_PASSWORD && \
az deployment sub create \
  --location swedencentral \
  --template-file demo-vm.bicep \
  --parameters demo-vm.bicepparam \
  --parameters adminPassword="$ADMIN_PASSWORD" && \
unset ADMIN_PASSWORD
```

**Alternative: Use Azure Key Vault**
```bash
# Store password in Key Vault first
az keyvault secret set --vault-name <your-keyvault> --name vm-admin-password --value '<password>'

# Reference it during deployment
az deployment sub create \
  --location swedencentral \
  --template-file demo-vm.bicep \
  --parameters demo-vm.bicepparam \
  --parameters adminPassword="@Microsoft.KeyVault(SecretUri=https://<your-keyvault>.vault.azure.net/secrets/vm-admin-password)"
```

#### 1. Validate the Bicep template

```bash
cd infra/bicep
az bicep build --file demo-vm.bicep
```

#### 2. Deploy using secure password input (Recommended)

```bash
read -sp "Enter admin password: " ADMIN_PASSWORD && \
az deployment sub create \
  --location swedencentral \
  --template-file demo-vm.bicep \
  --parameters demo-vm.bicepparam \
  --parameters adminPassword="$ADMIN_PASSWORD" && \
unset ADMIN_PASSWORD
```

#### 3. Deploy using parameters file (for testing only)

**Note:** This method exposes the password in command history. Use only for testing.

```bash
az deployment sub create \
  --location swedencentral \
  --template-file demo-vm.bicep \
  --parameters demo-vm.bicepparam \
  --parameters adminPassword='<YourSecurePassword123!>'
```

#### 4. Deploy with inline parameters (for testing only)

**Note:** This method exposes the password in command history. Use only for testing.

```bash
az deployment sub create \
  --location swedencentral \
  --template-file demo-vm.bicep \
  --parameters \
    resourceGroupName='rg-demo-vm' \
    location='swedencentral' \
    namePrefix='demo' \
    adminUsername='adminUser' \
    adminPassword='<YourSecurePassword123!>' \
    vmSize='Standard_B2ms' \
    windowsOSVersion='2022-Datacenter'
```

#### 5. What-If Deployment (preview changes)

```bash
az deployment sub what-if \
  --location swedencentral \
  --template-file demo-vm.bicep \
  --parameters demo-vm.bicepparam \
  --parameters adminPassword='<YourSecurePassword123!>'
```

### Password Requirements

The admin password must meet Azure VM password requirements:
- At least 12 characters long
- Contains at least one uppercase letter
- Contains at least one lowercase letter
- Contains at least one number
- Contains at least one special character

### Username Requirements

The admin username must:
- Be between 1-20 characters
- Not be a reserved Azure username (e.g., 'administrator', 'admin', 'root', 'guest', 'test', etc.)
- The template validates against a list of reserved names and will fail deployment if an invalid username is provided

### Available VM Sizes

The template supports the following VM sizes (2-4 vCPUs):
- `Standard_D2s_v3` - 2 vCPUs, 8 GB RAM
- `Standard_D4s_v3` - 4 vCPUs, 16 GB RAM
- `Standard_B2s` - 2 vCPUs, 4 GB RAM (burstable, low cost)
- `Standard_B2ms` - 2 vCPUs, 8 GB RAM (burstable, low cost) - **Default**

### Outputs

After successful deployment, the following information will be displayed:
- Resource Group name
- VM name
- Public IP address
- VM FQDN (Fully Qualified Domain Name)

### Connecting to the VM

Once deployed, you can connect to the VM via RDP:

```bash
# Get the public IP or FQDN from outputs
# Use Remote Desktop client to connect
# Username: adminUser (or your specified username)
# Password: The password you provided during deployment
```

### Clean Up Resources

To delete all deployed resources:

```bash
az group delete --name rg-demo-vm --yes --no-wait
```