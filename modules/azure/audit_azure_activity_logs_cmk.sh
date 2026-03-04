#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_activity_logs_cmk
#
# Check Azure Activity Logs CMK
#
# 6.1.1.3  Ensure that storage account is encrypted with customer-managed key
#
# Refer to Section(s) 6.1.1.3 Page(s) 203-6   CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_activity_logs_cmk () {
  print_function "audit_azure_activity_logs_cmk"
  check_message  "Azure Activity Logs CMK"
  command="az account list --query \"[].id\" --output tsv 2>/dev/null"
  command_message "${command}"
  sub_ids=$( eval "${command}" )
  for sub_id in ${sub_ids}; do
    command="az monitor diagnostic-settings subscription list --subscription ${sub_id} --query 'value[*].storageAccountId' --output tsv"
    command_message    "${command}"
    s_accounts=$( eval "${command}" 2> /dev/null )
    if [ -z "${s_accounts}" ]; then
      info_message "No Storage Accounts found"
      continue
    fi
    for s_account in ${s_accounts}; do
      command="az storage account show --name ${s_account} --query 'encryption.keySource' --output tsv 2>/dev/null"
      command_message    "${command}"
      key_source=$( eval "${command}" )
      command="az storage account show --name ${s_account} --query 'encryption.keyVaultProperties' --output tsv 2>/dev/null"
      command_message    "${command}"
      key_vault=$( eval  "${command}" )
      if [ "${key_source}" = "Microsoft.Keyvault" ]; then
        if [ ! -z "${key_vault}" ] && [ ! "${key_vault}" = "null" ]; then
          inc_secure   "Storage account ${s_account} is encrypted with customer-managed key"
        else
          inc_insecure "Storage account ${s_account} is encrypted with customer-managed key but no key vault is specified"
        fi
      else
        inc_insecure   "Storage account ${s_account} is not encrypted with customer-managed key"
      fi
    done 
  done
}
