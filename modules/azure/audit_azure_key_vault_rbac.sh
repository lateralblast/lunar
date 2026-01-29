#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_rbac
#
# Check Azure Key Vault RBAC
#
# 8.3.5 Ensure that Purge Protection is enabled for all Key Vaults
# Refer to Section(s) 8.3.5 Page(s) 440-3 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_rbac () {
  print_function  "audit_azure_key_vault_rbac"
  verbose_message "Azure Key Vault RBAC" "check"
  resource_names=$( az resource list --query "[?type=='Microsoft.KeyVault/vaults'].name" --output tsv )
  for resource_name in ${resource_names}; do
    resource_groups=$( az resource list --name "${resource_name}" --query "[].resourceGroup" --output tsv )
    for resource_group in ${resource_groups}; do
      check_azure_key_vault_value "${resource_name}" "${resource_group}" "properties.enableRbacAuthorization" "eq" "true"
    done
  done
}