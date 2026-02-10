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
  parameter_name="${4}"
  function="${5}"
  correct_value="${6}"
  set_name="${7}"
  if [ "${resource_group}" = "" ]; then
    verbose_message "${description} for Storage Account \"${storage_account}\" is \"${correct_value}\"" "check"
    command="az storage account show --name \"${storage_account}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
    actual_value=$( eval "${command}" )
    command_message "${command}"
    if [ "${function}" = "eq" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        increment_secure   "Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\""
      else
        increment_insecure "Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\""
        if [ ! -z "${set_name}" ]; then
          case "${set_name}" in
            "--"*)
              verbose_message    "az storage account update --name ${storage_account} ${set_name} ${correct_value}" "fix"
              ;;
            *)
              verbose_message    "az storage account update --name ${storage_account} --set ${set_name}=${correct_value}" "fix"
              ;;
          esac
        fi
      fi
    else
      if [ "${function}" = "ne" ]; then
        if [ "${actual_value}" != "${correct_value}" ]; then
          increment_secure   "Storage Account \"${storage_account}\" does not have ${description} "${function}" to "${correct_value}"
        else
          increment_insecure "Storage Account \"${storage_account}\" has ${description} "${function}" to "${correct_value}"
          if [ ! -z "${set_name}" ]; then
            case "${set_name}" in
              "--"*)
                verbose_message    "az storage account update --name ${storage_account} ${set_name} ${correct_value}" "fix"
                ;;
              *)
                verbose_message    "az storage account update --name ${storage_account} --set ${set_name}=${correct_value}" "fix"
                ;;
            esac
          fi
        fi
      fi
    fi
  else
    resource_group=$( az storage account show --name "${storage_account}" --query "resourceGroup" --output tsv )
    verbose_message "${description} for Storage Account \"${storage_account}\" Resource Group \"${resource_group}\" is \"${correct_value}\"" "check"
    actual_value=$( az storage account show --name "${storage_account}" --resource-group "${resource_group}" --query "${parameter_name}" --output tsv )
    if [ "${function}" = "eq" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        increment_secure   "Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
      else
        increment_insecure "Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
        if [ ! -z "${set_name}" ]; then
          case "${set_name}" in
            "--"*)
              verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value}" "fix"
              ;;
            *)
              verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} --set ${set_name}=${correct_value}" "fix"
              ;;
          esac
        fi
      fi
    else
      if [ "${function}" = "ne" ]; then
        if [ "${actual_value}" != "${correct_value}" ]; then
          increment_secure   "Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
        else
          increment_insecure "Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\" for resource group \"${resource_group}\""
          if [ ! -z "${set_name}" ]; then
            case "${set_name}" in
              "--"*)
                verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value}" "fix"
                ;;
              *)
                verbose_message    "az storage account update --name ${storage_account} --resource-group ${resource_group} --set ${set_name}=${correct_value}" "fix"
                ;;
            esac
          fi
        fi
      fi
    fi
  fi
}
