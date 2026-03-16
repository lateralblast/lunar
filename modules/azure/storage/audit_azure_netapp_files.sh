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
  print_function "audit_azure_netapp_files"
  check_message  "Azure NetApp Files"
  command="az netappfiles account list --query \"[].name\" --output tsv"
  command_message    "${command}"
  s_accounts=$( eval "${command}" )
  if [ -z "${s_accounts}" ]; then
    info_message "No NetApp Files instances found"
    return
  fi
  for s_account in ${s_accounts}; do
    command="az netappfiles account show --name \"${s_account}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    # 10.1 Ensure 'Encryption key source' is set to 'Customer Managed Key' for Azure NetApp Files accounts
    check_azure_netapp_file_value "Encryption key source" "${s_account}" "${res_group}" "encryptionKeySource" "eq" "CustomerManagedKey"
  done
}
