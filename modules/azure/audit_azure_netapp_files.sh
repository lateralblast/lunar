#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_netapp_files
#
# Check Azure NetApp Files
#
# 10.1 Ensure 'Encryption key source' is set to 'Customer Managed Key' for Azure NetApp Files accounts
#
# Refer to Sections(s) 10 Page(s) 120-4 Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_netapp_files () {
  print_function  "audit_azure_netapp_files"
  verbose_message "Azure NetApp Files" "check"
  command="az netappfiles account list --query \"[].name\" --output tsv"
  command_message "${command}"
  storage_accounts=$( eval "${command}" )
  for storage_account in ${storage_accounts}; do
    command="az netappfiles account show --name \"${storage_account}\" --query \"resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    # 10.1 Ensure 'Encryption key source' is set to 'Customer Managed Key' for Azure NetApp Files accounts
    check_azure_netapp_file_value "Encryption key source" "${storage_account}" "${resource_group}" "encryptionKeySource" "eq" "CustomerManagedKey"
  done
}
