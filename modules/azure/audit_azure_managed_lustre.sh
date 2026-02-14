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
  print_function  "audit_azure_managed_lustre"
  verbose_message "Azure Managed Lustre" "check"
  command="az storage account list --query \"[].name\" --output tsv"
  command_message "${command}"
  storage_accounts=$( eval "${command}" )
  for storage_account in ${storage_accounts}; do
    command="az amlfs list --query \"[].resourceGroup\" --output tsv"
    command_message "${command}"
    resource_groups=$( eval "${command}" )
    for resource_group in ${resource_groups}; do
      command="az amlfs list --resource-group \"${resource_group}\" --query \"[].name\" --output tsv"
      command_message "${command}"
      file_systems=$( eval "${command}" )
      for file_system in ${file_systems}; do
        # 4.1 Ensure 'Key encryption key' is set to a customer-managed key for Azure Managed Lustre file systems
        check_azure_storage_fs_value "Key encryption key name"      "${storage_account}" "${file_system}" "encryption.keyEncryptionKeyId.keyName"     "ne" ""
        check_azure_storage_fs_value "Key encryption key vault uri" "${storage_account}" "${file_system}" "encryption.keyEncryptionKeyId.keyVaultUri" "ne" ""
      done
    done
  done
}
