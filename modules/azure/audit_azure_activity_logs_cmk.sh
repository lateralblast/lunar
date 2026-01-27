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
  subscription_ids=$( az account list --query "[].id" --output tsv 2>/dev/null )
  for subscription_id in ${subscription_ids}; do
    storage_accounts=$( az monitor diagnostic-settings subscription list --subscription ${subscription_id} --query 'value[*].storageAccountId' --output tsv )
    for storage_account in ${storage_accounts}; do
      key_source=$( az storage account show --name ${storage_account} --query 'encryption.keySource' --output tsv 2>/dev/null )
      key_vault=$( az storage account show --name ${storage_account} --query 'encryption.keyVaultProperties' --output tsv 2>/dev/null )
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
