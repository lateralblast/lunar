#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_keys
#
# Check Azure Key Vault Keys
#
# 8.3.1 Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults
# Refer to Section(s) 8.3.1 Page(s) 425-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_keys () {
  print_function  "audit_azure_key_vault_keys"
  verbose_message "Azure Key Vault Keys" "check"
  key_vaults=$( az keyvault list --query "[].name" --output tsv )
  for key_vault in ${key_vaults}; do
    key_list=$( az keyvault key list --vault-name "${key_vault}" --query "[].name" --output tsv )
    for key_name in ${key_list}; do
      check_azure_key_vault_value "${key_vault}" "${key_name}" "attributes.enabled" "eq" "true" 
      check_azure_key_vault_value "${key_vault}" "${key_name}" "attributes.expired" "ne" "" 
    done
  done
}
