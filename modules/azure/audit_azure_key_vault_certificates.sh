#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_certificates
#
# Check Azure Key Vault Certificates
#
# 2.5 Ensure Azure Key Vaults are Used to Store Secrets
#
# Refer to Section(s) 2.5 Page(s) 238-42 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_certificates () {
  print_function  "audit_azure_key_vault_certificates"
  verbose_message "Azure Key Vault Certificates" "check"
  command="az keyvault list --query \"[].id\" --output tsv"
  command_message "${command}"
  key_vaults=$( eval "${command}" 2> /dev/null )
  if [ -z "${key_vaults}" ]; then
    insecure_message "No Key Vault Certificates found"
  else
    secure_message   "Key Vault Certificates found"
  fi
}
