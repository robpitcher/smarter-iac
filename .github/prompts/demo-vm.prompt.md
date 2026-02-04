# Demo IaC Generator: Azure VM + Network

You are generating demo IaC for Azure for infrastructure engineers/DevOps personas.

## Parameters
IaC Language: ${input:iacLanguage:Language to use for IaC code generation (e.g., bicep or terraform)}

## Requirements
- Use the IaC language specified by ${input:iacLanguage}.
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
- Update the README.md in the IaC language folder to document how to deploy the generated IaC code.
- Create a `.bicepparam` or `.tfvars` file with example parameter values (no secrets).
- Ensure the IaC is deployable by verifying lint errors are resolved, and validation passes.