#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_backup_vault_value
#
# Check Azure Backup values
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_backup_vault_value () {
  description="${1}"
  workspace_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  parameter_name="${7}"
  print_function  "check_azure_backup_vault_value"
  verbose_message "Azure Backup Vault ${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az backup vault show --name \"${workspace_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure Backup Vault ${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Azure Backup Vault ${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${parameter_name}" = "" ]; then
        verbose_message  "az backup vault update --name \"${workspace_name}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" --output tsv" "fix"
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Azure Backup Vault ${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${parameter_name}" = "" ]; then
        verbose_message  "az backup vault update --name \"${workspace_name}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" --output tsv" "fix"
      fi
    else
      increment_secure   "Azure Backup Vault ${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
