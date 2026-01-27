#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_resource_manager_lock
#
# Check Azure Resource Manager Lock
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_resource_manager_lock () {
  description="${1}"
  storage_account="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  resource_type="${7}"
  actual_value=$( az resource lock list --resource-group "${resource_group}" --resource-type "${resource_type}" --resource-name "${storage_account}" --query "${query_string}" --output tsv )
  verbose_message "${description} for Storage Account \"${storage_account}\" with resource group \"${resource_group}\" and resource type \"${resource_type}\" had a \"${correct_value}\" lock applied" "check"
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Storage Account \"${storage_account}\" with resource group \"${resource_group}\" and resource type \"${resource_type}\" has a \"${correct_value}\" lock applied"
  else
    increment_insecure "Storage Account \"${storage_account}\" with resource group \"${resource_group}\" and resource type \"${resource_type}\" does not have a \"${correct_value}\" lock applied"
    verbose_message    "az lock create --name ${correct_value} --resource-group ${resource_group} --resource-name ${storage_account} --resource-type ${resource_type} --lock-type ${correct_value}" "fix"
  fi
}
