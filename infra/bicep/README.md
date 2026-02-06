# Bicep IaC

Subscription-scoped Bicep template that provisions a low-cost Windows Server VM with a virtual network, subnet, NSG, NIC, public IP, and managed OS disk in Sweden Central.

## Files
- `main.bicep` – subscription-scope deployment that creates the resource group, networking, public IP, NIC, and VM
- `main.bicepparam` – sample parameters (replace `adminPassword` at deploy time with a strong value)

## Deploy
1. Log in and select your subscription
   ```bash
   az login
   az account set --subscription "<subscription-id>"
   ```
2. Validate the template locally
   ```bash
   bicep build infra/bicep/main.bicep
   ```
3. Validate against Azure (adds no resources)
   ```bash
   az deployment sub validate \
     --location swedencentral \
     --name demoValidation \
     --template-file infra/bicep/main.bicep \
     --parameters @infra/bicep/main.bicepparam \
     --parameters adminPassword="<strong-password>"
   ```
4. Deploy
   ```bash
   az deployment sub create \
     --location swedencentral \
     --name demoDeployment \
     --template-file infra/bicep/main.bicep \
     --parameters @infra/bicep/main.bicepparam \
     --parameters adminPassword="<strong-password>"
   ```
5. After deployment, retrieve the public IP from the deployment outputs or the `publicIpAddress` resource if you need to RDP to the VM. Add an NSG rule for RDP if required.
