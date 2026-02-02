#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_container_value
#
# Check Azure Storage Container Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_container_value () {
  print_function  "check_azure_storage_container_value"
  description="${1}"
  storage_account="${2}"
  resource_group="${3}"
  container_propery="${4}"
  parameter_name="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  if [ "${resource_group}" = "" ]; then
    verbose_message "${description} for Storage Containers on Storage Account \"${storage_account}\" is \"${correct_value}\"" "check"
    command="az storage account blob-${container_propery} show --account-name \"${storage_account}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
    actual_value=$( eval "${command}" )
    command_message "${command}"
  else
    verbose_message "${description} for Storage Containers on Storage Account \"${storage_account}\" Resource Group \"${resource_group}\" is \"${correct_value}\"" "check"
    command="az storage account blob-${container_propery} show --account-name \"${storage_account}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
    actual_value=$( eval "${command}" )
    command_message "${command}"
  fi
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Storage Containers on Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\""
  else
    increment_insecure "Storage Containers on Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\""
    if [ ! -z "${set_name}" ]; then
      if [ "${resource_group}" = "" ]; then
        if [[ ${set_name} =~ -- ]]; then
          verbose_message    "az storage account blob-${container_propery} update --account-name ${storage_account} ${set_name} ${correct_value}" "fix"
        else
          verbose_message    "az storage account blob-${container_propery} update --account-name ${storage_account} --set ${set_name}=${correct_value}" "fix"
        fi
      else
        if [[ ${set_name} =~ -- ]]; then
          verbose_message    "az storage account blob-${container_propery} update --account-name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value}" "fix"
        else
          verbose_message    "az storage account blob-${container_propery} update --account-name ${storage_account} --resource-group ${resource_group} --set ${set_name}=${correct_value}" "fix"
        fi
      fi
    fi
  fi
}
