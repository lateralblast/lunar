#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_account_container_value
#
# Check Azure Storage Account Container value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_account_container_value () {
  description="${1}"
  storage_account="${2}"
  resource_group="${3}"
  container_property="${4}"
  parameter_name="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  print_function "check_azure_storage_account_container_value"
  if [ "${resource_group}" = "" ]; then
    check_message "${description} for Storage Containers on Storage Account \"${storage_account}\" is \"${correct_value}\""
    command="az storage account blob-${container_property} show --account-name \"${storage_account}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
    command_message      "${command}"
    actual_value=$( eval "${command}" )
  else
    check_message "${description} for Storage Containers on Storage Account \"${storage_account}\" Resource Group \"${resource_group}\" is \"${correct_value}\""
    command="az storage account blob-${container_property} show --account-name \"${storage_account}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
    command_message      "${command}"
    actual_value=$( eval "${command}" )
  fi
  if [ "${actual_value}" = "${correct_value}" ]; then
    inc_secure   "${description} for Storage Containers on Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\""
  else
    inc_insecure "${description} for Storage Containers on Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\""
    if [ ! -z "${set_name}" ]; then
      if [ "${resource_group}" = "" ]; then
        case "${set_name}" in
          "--"*)
            fix_message "az storage account blob-${container_property} update --account-name ${storage_account} ${set_name} ${correct_value}"
            ;;
          *)
            fix_message "az storage account blob-${container_property} update --account-name ${storage_account} --set ${set_name}=${correct_value}"
            ;;
        esac
      else
        case "${set_name}" in
          "--"*)
            fix_message "az storage account blob-${container_property} update --account-name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value}"
            ;;
          *)
            fix_message "az storage account blob-${container_property} update --account-name ${storage_account} --resource-group ${resource_group} --set ${set_name}=${correct_value}"
            ;;
        esac
      fi
    fi
  fi
}
