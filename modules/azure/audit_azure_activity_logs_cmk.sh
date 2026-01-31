#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_activity_logs_cmk
#
# Check Azure Activity Logs CMK
#
# 6.1.1.3  Ensure that storage account is encrypted with customer-managed key
# Refer to Section(s) 6.1.1.3 Page(s) 203-6   CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_activity_logs_cmk () {
  print_function "audit_azure_activity_logs_cmk"
  verbose_message "Azure Activity Logs CMK" "check"
  command="az account list --query \"[].id\" --output tsv 2>/dev/null"
  command_message "${command}" "exec"
  subscription_ids=$( eval "${command}" )
  for subscription_id in ${subscription_ids}; do
    command="az monitor diagnostic-settings subscription list --subscription ${subscription_id} --query 'value[*].storageAccountId' --output tsv"
    command_message "${command}" "exec"
    storage_accounts=$( eval "${command}" )
    for storage_account in ${storage_accounts}; do
      command="az storage account show --name ${storage_account} --query 'encryption.keySource' --output tsv 2>/dev/null"
      command_message "${command}" "exec"
      key_source=$( eval "${command}" )
      command="az storage account show --name ${storage_account} --query 'encryption.keyVaultProperties' --output tsv 2>/dev/null"
      command_message "${command}" "exec"
      key_vault=$( eval "${command}" )
      if [ "${key_source}" = "Microsoft.Keyvault" ]; then
        if [ ! -z "${key_vault}" ] && [ ! "${key_vault}" = "null" ]; then
          increment_secure   "Storage account ${storage_account} is encrypted with customer-managed key"
        else
          increment_insecure "Storage account ${storage_account} is encrypted with customer-managed key but no key vault is specified"
        fi
      else
        increment_insecure "Storage account ${storage_account} is not encrypted with customer-managed key"
      fi
    done 
  done
}
