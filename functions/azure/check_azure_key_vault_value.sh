#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_key_vault_value
#
# Check Azure Key Vault values
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

check_azure_key_vault_value () {
  resource_name="${1}"
  resource_group="${2}"
  parameter_name="${3}"
  function="${4}"
  correct_value="${5}"
  set_name="${6}"
  print_function  "check_azure_key_vault_value"
  verbose_message "Key with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\"" "check"
  actual_value=$( az keyvault show --resource-group "${resource_group}" --name "${resource_name}" --query "${parameter_name}" --output tsv 2> /dev/null )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "Key with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Key with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
      verbose_message "az keyvault update --resource-group ${resource_group} --name ${resource_name} ${set_name} ${correct_value}" "fix"
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Key with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
      verbose_message "az keyvault update --resource-group ${resource_group} --name ${resource_name} ${set_name} ${correct_value}" "fix"
    else
      increment_secure "Key with resource name \"${resource_name}\" in resource group \"${resource_group}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
