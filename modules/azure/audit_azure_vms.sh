#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_vms
#
# Check Azure Virtual Machines
#
# 20.1    Ensure Virtual Machines are utilizing Managed Disks
# 20.2    Ensure that 'OS and Data' disks are encrypted with 'Customer Managed Key' (CMK)
# 20.3    Ensure that 'Unattached disks' are encrypted with 'Customer Managed Key' (CMK)
# 20.4    Ensure that 'Disk Network Access' is NOT set to 'Enable public access from all networks'
# 20.5    Ensure that 'Enable Data Access Authentication Mode' is 'Checked'
# 20.6    Ensure that Only Approved Extensions Are Installed
# 20.7    Ensure that Endpoint Protection for all Virtual Machines is installed
# 20.8    [Legacy] Ensure that VHDs are Encrypted
# 20.9    Ensure only MFA enabled identities can access privileged Virtual Machine 
# 20.10   Ensure Trusted Launch is enabled on Virtual Machines 
# 20.11   Ensure that encryption at host is enabled
#
# Refer to Section(s) 20 Page(s) 307-41 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_vms () {
  print_function "audit_azure_vms"
  verbose_message "Azure Virtual Machines" "check"
}
