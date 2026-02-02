#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_key_vault_keys
#
# Check Azure Key Vault Keys
#
# 8.3.1 Ensure that the Expiration Date is set for all Keys in RBAC Key Vaults
# 8.3.2 Ensure that the Expiration Date is set for all Keys in Non-RBAC Key Vaults
# 8.3.3 Ensure that the Expiration Date is set for all Secrets in RBAC Key Vaults
# 8.3.4 Ensure that the Expiration Date is set for all Secrets in Non-RBAC Key Vaults
# 8.3.9 Ensure automatic key rotation is enabled within Azure Key Vault
# Refer to Section(s) 8.3.1-4,9 Page(s) 425-39,456-9 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# Azure and NIST recommend that keys be rotated every two years or less. Refer to
# 'Table 1: Suggested cryptoperiods for key types' on page 46 of the following document
# for more information:
# https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

audit_azure_key_vault_keys () {
  print_function  "audit_azure_key_vault_keys"
  verbose_message "Azure Key Vault Keys" "check"
  command="az keyvault list --query \"[].name\" --output tsv"
  command_message "${command}"
  key_vaults=$( eval "${command}" )
  for key_vault in ${key_vaults}; do
    command="az keyvault key list --vault-name \"${key_vault}\" --query \"[].name\" --output tsv"
    command_message "${command}"
    key_list=$( eval "${command}" )
    for key_name in ${key_list}; do
      check_azure_key_vault_key_value "${key_vault}" "${key_name}" "attributes.enabled"     "eq" "true" ""                ""
      check_azure_key_vault_key_value "${key_vault}" "${key_name}" "attributes.expired"     "ne" ""     ""                ""
      check_azure_key_vault_key_value "${key_vault}" "${key_name}" ""                       "ne" ""     "rotation-policy" "Notify"
      check_azure_key_vault_key_value "${key_vault}" "${key_name}" "timeAfterCreate"        "ne" ""     "rotation-policy" "Notify"
      check_azure_key_vault_key_value "${key_vault}" "${key_name}" ""                       "ne" ""     "rotation-policy" "Rotate"
      check_azure_key_vault_key_value "${key_vault}" "${key_name}" "timeAfterCreate"        "ne" ""     "rotation-policy" "Rotate"
    done
  done
}
