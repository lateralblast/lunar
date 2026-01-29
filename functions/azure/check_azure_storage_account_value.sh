#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_account_value
#
# Check Azure Storage Account Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_account_value () {
  print_function  "check_azure_storage_account_value"
  description="${1}"
  storage_account="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  parameter_name="${7}"
  if [ "${resource_group}" = "" ]; then
    verbose_message "${description} for Storage Account \"${storage_account}\" is \"${correct_value}\"" "check"
    actual_value=$( az storage account show --name "${storage_account}" --query "${query_string}" --output tsv )
    if [ "${function}" = "eq" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        increment_secure   "Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\""
      else
        increment_insecure "Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\""
        if [ ! -z "${parameter_name}" ]; then
          if [[ ${parameter_name} =~ -- ]]; then
            verbose_message    "az storage account update --name ${storage_account} ${parameter_name} ${correct_value}" "fix"
          else
            verbose_message    "az storage account update --name ${storage_account} --set ${parameter_name}=${correct_value}" "fix"
          fi
        fi
      fi
    else
      if [ "${function}" = "ne" ]; then
        if [ "${actual_value}" != "${correct_value}" ]; then
          increment_secure   "Storage Account \"${storage_account}\" does not have ${description} "${function}" to "${correct_value}"
        else
          increment_insecure "Storage Account \"${storage_account}\" has ${description} "${function}" to "${correct_value}"
          if [ ! -z "${parameter_name}" ]; then
            if [[ ${parameter_name} =~ -- ]]; then
              verbose_message    "az storage account update --name ${storage_account} ${parameter_name} ${correct_value}" "fix"
            else
              verbose_message    "az storage account update --name ${storage_account} --set ${parameter_name}=${correct_value}" "fix"
            fi
          fi
        fi
      fi
    fi
  else
    resource_group=$( az storage account show --name "${storage_account}" --query "resourceGroup" --output tsv )
    verbose_message "${description} for Storage Account \"${storage_account}\" Resource Group \"${resource_group}\" is \"${correct_value}\"" "check"
    actual_value=$( az storage account show --name "${storage_account}" --resource-group "${resource_group}" --query "${query_string}" --output tsv )
    if [ "${function}" = "eq" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        increment_secure   "Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
      else
        increment_insecure "Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
        if [ ! -z "${parameter_name}" ]; then
          if [[ ${parameter_name} =~ -- ]]; then
            verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} ${parameter_name} ${correct_value}" "fix"
          else
            verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} --set ${parameter_name}=${correct_value}" "fix"
          fi
        fi
      fi
    else
      if [ "${function}" = "ne" ]; then
        if [ "${actual_value}" != "${correct_value}" ]; then
          increment_secure   "Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
        else
          increment_insecure "Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
          if [ ! -z "${parameter_name}" ]; then
            if [[ ${parameter_name} =~ -- ]]; then
              verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} ${parameter_name} ${correct_value}" "fix"
            else
              verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} --set ${parameter_name}=${correct_value}" "fix"
            fi
          fi
        fi
      fi
    fi
  fi
}
