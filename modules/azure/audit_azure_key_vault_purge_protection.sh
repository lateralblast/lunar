#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_purge_protection
#
# Check Azure Key Vault Purge Protection
#
# 8.3.5 Ensure that Purge Protection is enabled for all Key Vaults
#
# Refer to Section(s) 8.3.5 Page(s) 440-3 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_purge_protection () {
  print_function "audit_azure_key_vault_purge_protection"
  check_message  "Azure Key Vault Purge Protection"
  command="az resource list --query \"[?type=='Microsoft.KeyVault/vaults'].name\" --output tsv"
  command_message   "${command}"
  res_names=$( eval "${command}" 2> /dev/null )
  if [ -z "${res_names}" ]; then
    info_message "No Key Vaults found"
    return
  fi
  for res_name in ${res_names}; do
    command="az resource list --name \"${res_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message         "${command}"
    res_groups=$( eval "${command}" )
    for res_group in ${res_groups}; do
      command="az resource show --resource-group \"${res_group}\" --name \"${res_name}\" --resource-type \"Microsoft.KeyVault/vaults\" --query \"properties.enablePurgeProtection\" --output tsv"
      command_message    "${command}"
      protection=$( eval "${command}" )
      check_message "Azure Key Vault \"${res_name}\" purge protection"
      if [ "${protection}" = "true" ]; then
        inc_secure   "Azure Key Vault \"${res_name}\" purge protection is enabled"
      else
        inc_insecure "Azure Key Vault \"${res_name}\" purge protection is not enabled"
        verbose_message    "az resource update --resource-group ${res_group} --name ${res_name} --resource-type \"Microsoft.KeyVault/vaults\" --set properties.enablePurgeProtection=true" "fix"
      fi
    done
  done
}
