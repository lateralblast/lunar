#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_subscription_diagnostic_settings
#
# Check Azure Subscription Diagnostic Settings
#
# Refer to Section(s) 6.1.1.1 Page(s) 194-8   CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.1.2 Page(s) 199-202 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.1.3 Page(s) 203-6   CIS Microsoft Azure Foundations Benchmark v5.0.0
#.
audit_azure_subscription_diagnostic_settings () {
  print_function "audit_azure_subscription_diagnostic_settings"
  verbose_message "Azure Subscription Diagnostic Settings" "check"
  subscription_ids=$( az account list --query "[].id" -o tsv 2>/dev/null )
  for subscription_id in ${subscription_ids}; do
    diagnostic_settings=$( az monitor diagnostic-settings list --scope /subscriptions/${subscription_id} --query "[].value" -o tsv 2>/dev/null )
    if [ -z "${diagnostic_settings}" ]; then
      increment_insecure "There are no diagnostic settings for subscription ${subscription_id}"
    else
      increment_secure   "There are diagnostic settings for subscription ${subscription_id}"
    fi
    resource_ids=$( az resource list --subscription ${subscription_id} --query "[].id" -o tsv )
    for resource_id in ${resource_ids}; do
      diagnostic_settings=$( az monitor diagnostic-settings list --resource ${resource_id} --query "[].value" -o tsv 2>/dev/null )
      if [ -z "${diagnostic_settings}" ]; then
        increment_insecure "There are no diagnostic settings for resource ${resource_id}"
      else
        increment_secure   "There are diagnostic settings for resource ${resource_id}"
      fi    
    done
    for setting in Administrative Alert Policy Security; do
      diagnostic_setting=$( az monitor diagnostic-settings subscription list --subscription ${subscription_id} | grep "${setting}" | grep -i "enabled" | grep true )
      if [ -z "${diagnostic_setting}" ]; then
        increment_insecure "There is no diagnostic setting for ${setting} for subscription ${subscription_id}"
      else
        increment_secure   "There is a diagnostic setting for ${setting} for subscription ${subscription_id}"
      fi
    done
    storage_accounts=$( az monitor diagnostic-settings subscription list --subscription ${subscription_id} --query 'value[*].storageAccountId' -o tsv )
    for storage_account in ${storage_accounts}; do
      key_source=$( az storage account show --name ${storage_account} --query 'encryption.keySource' -o tsv 2>/dev/null )
      key_vault=$( az storage account show --name ${storage_account} --query 'encryption.keyVaultProperties' -o tsv 2>/dev/null )
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