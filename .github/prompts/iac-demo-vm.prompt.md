# Demo IaC Generator: Azure VM + Network

You are generating demo IaC for Azure for infrastructure engineers/DevOps personas.

## Parameters
- **iacLanguage**: `bicep` or `terraform`

## Requirements
- Create a **virtual machine** and associated resources:
  - Azure region: Sweden Central
  - Operating Systems: Windows Server
  - Virtual Network + Subnet: Use default address spaces
  - VM Size: Use a common, low-cost size suitable for demo
  - Network Security Group (NSG) with default rules
  - Network Interface (NIC)
  - Managed OS Disk
  - Public IP (for demo access)
- Keep defaults low-cost and demo-friendly.
- Do **not** output secrets or keys.
- Assume deployment scope is **subscription** (include resource group creation).
