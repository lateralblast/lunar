#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_purge_protection
#
# Check Azure Key Vault Purge Protection
#
# 8.3.5 Ensure that Purge Protection is enabled for all Key Vaults
# Refer to Section(s) 8.3.5 Page(s) 440-3 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_purge_protection () {
  print_function  "audit_azure_key_vault_purge_protection"
  verbose_message "Azure Key Vault Purge Protection" "check"
  command="az resource list --query \"[?type=='Microsoft.KeyVault/vaults'].name\" --output tsv"
  command_message "${command}" "exec"
  resource_names=$( eval "${command}" )
  for resource_name in ${resource_names}; do
    command="az resource list --name \"${resource_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message "${command}" "exec"
    resource_groups=$( eval "${command}" )
    for resource_group in ${resource_groups}; do
      command="az resource show --resource-group \"${resource_group}\" --name \"${resource_name}\" --resource-type \"Microsoft.KeyVault/vaults\" --query \"properties.enablePurgeProtection\" --output tsv"
      command_message "${command}" "exec"
      purge_protection=$( eval "${command}" )
      verbose_message "Azure Key Vault \"${resource_name}\" purge protection" "check"
      if [ "${purge_protection}" = "true" ]; then
        increment_secure   "Azure Key Vault \"${resource_name}\" purge protection is enabled"
      else
        increment_insecure "Azure Key Vault \"${resource_name}\" purge protection is not enabled"
        verbose_message    "az resource update --resource-group ${resource_group} --name ${resource_name} --resource-type "Microsoft.KeyVault/vaults" --set properties.enablePurgeProtection=true" "fix"
      fi
    done
  done
}
