#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_public_network_access
#
# Check Azure Key Vault Public Network Access
#
# 8.3.7 Ensure Public Network Access is Disabled
#
# Refer to Section(s) 8.3.7 Page(s) 447-50 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_public_network_access () {
  print_function  "audit_azure_key_vault_public_network_access"
  verbose_message "Azure Key Vault Public Network Access" "check"
  command="az resource list --query \"[?type=='Microsoft.KeyVault/vaults'].name\" --output tsv"
  command_message "${command}"
  resource_names=$( eval "${command}" 2> /dev/null )
  if [ -z "${resource_names}" ]; then
    verbose_message "No Key Vaults found" "info"
    return
  fi
  for resource_name in ${resource_names}; do
    command="az resource list --name \"${resource_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message "${command}"
    resource_groups=$( eval "${command}" )
    for resource_group in ${resource_groups}; do
      check_azure_key_vault_value "${resource_name}" "${resource_group}" "properties.publicNetworkAccess" "eq" "Disabled" "--public-network-access"
    done
  done
}
