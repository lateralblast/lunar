#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_private_endpoints
#
# Check Azure Key Vault Private Endpoints
#
# 8.3.7 Ensure Public Network Access is Disabled
#
# Refer to Section(s) 8.3.7 Page(s) 447-50 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_private_endpoints () {
  print_function "audit_azure_key_vault_private_endpoints"
  check_message  "Azure Key Vault Private Endpoints"
  command="az resource list --query \"[?type=='Microsoft.KeyVault/vaults'].name\" --output tsv"
  command_message   "${command}"
  res_names=$( eval "${command}" 2> /dev/null )
  if [ -z "${res_names}" ]; then
    info_message "No Key Vaults found"
    return
  fi
  for res_name in ${res_names}; do
    command="az resource list --name \"${res_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message    "${command}"
    res_groups=$( eval "${command}" )
    for res_group in ${res_groups}; do
      check_azure_key_vault_value "${res_name}" "${res_group}" "properties.privateEndpointConnections" "ne" "" ""
    done
  done
}
