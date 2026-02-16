#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_file_share_value
#
# Check Azure File Share Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_file_share_value () {
  print_function  "check_azure_file_share_value"
  description="${1}"
  storage_account="${2}"
  resource_group="${3}"
  share_propery="${4}"
  parameter_name="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  retention_days="${9}"
  verbose_message "${description} for Shares on Storage Account \"${storage_account}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az storage account file-${share_propery} show --account-name \"${storage_account}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Shares for Storage Account \"${storage_account}\" has ${description} \"${function}\" to \"${correct_value}\""
  else
    increment_insecure "Shares for Storage Account \"${storage_account}\" does not have ${description} \"${function}\" to \"${correct_value}\""
    if [ ! -z "${set_name}" ]; then
      case "${set_name}" in
        "--"*)
          if [ "${retention_days}" = "" ]; then
            verbose_message  "az storage account file-${share_propery} update --name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value}" "fix"
          else
            verbose_message  "az storage account file-${share_propery} update --name ${storage_account} --resource-group ${resource_group} ${set_name} ${correct_value} --retention-days ${retention_days}" "fix"
          fi
          ;;
        *)
          verbose_message    "az storage account file-${share_propery} update --name ${storage_account} --resource-group ${resource_group} --set ${set_name}=${correct_value}" "fix"
          ;;
      esac
    fi
  fi
}
