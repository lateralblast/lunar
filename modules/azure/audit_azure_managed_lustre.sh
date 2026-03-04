#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_managed_lustre
#
# Check Azure Managed Lustre
#
# 4.1 Ensure 'Key encryption key' is set to a customer-managed key for Azure Managed Lustre file systems
#
# Refer to Section(s) 4.1 Page(s) 53-6 CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_managed_lustre () {
  print_function "audit_azure_managed_lustre"
  check_message  "Azure Managed Lustre"
  command="az storage account list --query \"[].name\" --output tsv"
  command_message    "${command}"
  s_accounts=$( eval "${command}" 2> /dev/null )
  if [ -z "${s_accounts}" ]; then
    info_message "No Storage Accounts found"
    return
  fi
  for s_account in ${s_accounts}; do
    command="az amlfs list --query \"[].resourceGroup\" --output tsv"
    command_message    "${command}"
    res_groups=$( eval "${command}" )
    if [ -z "${resource_groups}" ]; then
      info_message "No Managed Lustre instances found"
      return
    fi
    for res_group in ${res_groups}; do
      command="az amlfs list --resource-group \"${res_group}\" --query \"[].name\" --output tsv"
      command_message      "${command}"
      file_systems=$( eval "${command}" )
      for file_system in ${file_systems}; do
        # 4.1 Ensure 'Key encryption key' is set to a customer-managed key for Azure Managed Lustre file systems
        check_azure_storage_fs_value "Key encryption key name"      "${s_account}" "${file_system}" "encryption.keyEncryptionKeyId.keyName"     "ne" ""
        check_azure_storage_fs_value "Key encryption key vault uri" "${s_account}" "${file_system}" "encryption.keyEncryptionKeyId.keyVaultUri" "ne" ""
      done
    done
  done
}
