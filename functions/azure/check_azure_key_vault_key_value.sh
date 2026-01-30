#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_key_vault_key_value
#
# Check Azure Key Vault key values
#
# This requires the Azure CLI to be installed and configured
# Audit account needs to have the 'Key Vault Reader' role
# To do any changes to the key vaults, the 'Key Vault Administrator' role is required
#.

check_azure_key_vault_key_value () {
  key_vault="${1}"
  key_name="${2}"
  parameter_name="${3}"
  function="${4}"
  correct_value="${5}"
  policy_name="${6}"
  action_value="${7}"
  print_function  "check_azure_key_vault_key_value"
  verbose_message "Key \"${key_name}\" in key vault \"${key_vault}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\"" "check"
  if [ "${policy_name}" = "" ]; then
    command="az keyvault key show --vault-name \"${key_vault}\" --name \"${key_name}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
    command_message "${command}"
    actual_value=$( eval "${command}" )
  else
    if [ "${parameter_name}" = "" ]; then
      query_string="lifetimeActions[?contains(action, '${action_value}')]"
    else
      query_string="lifetimeActions[?contains(action, '${action_value}')].${parameter_name}"
    fi
    command="az keyvault key ${policy_name} show --vault-name \"${key_vault}\" --name \"${key_name}\" --query \"${query_string}\" --output tsv 2> /dev/null"
    command_message "${command}"
    actual_value=$( eval "${command}" )
  fi
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "Key \"${key_name}\" in key vault \"${key_vault}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Key \"${key_name}\" in key vault \"${key_vault}\" with parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Key \"${key_name}\" in key vault \"${key_vault}\" with parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
    else
      increment_secure "Key \"${key_name}\" in key vault \"${key_vault}\" with parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
