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
  query_string="${5}"
  function="${6}"
  correct_value="${7}"
  parameter_name="${8}"
  retention_days="${9}"
  verbose_message "${description} for Shares on Storage Account \"${storage_account}\" is \"${correct_value}\"" "check"
  actual_value=$( az storage account file-${share_propery} show --account-name "${storage_account}" --resource-group "${resource_group}" --query "${query_string}" --output tsv )
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Shares for Storage Account \"${storage_account}\" has ${description} set to ${correct_value}"
  else
    increment_insecure "Shares for Storage Account \"${storage_account}\" does not have ${description} set to ${correct_value}"
    if [ ! -z "${parameter_name}" ]; then
      if [[ ${parameter_name} =~ -- ]]; then
        if [ "${retention_days}" = "" ]; then
          verbose_message    "az storage account file-${share_propery} update --name ${storage_account} --resource-group ${resource_group} ${parameter_name} ${correct_value}" "fix"
        else
          verbose_message    "az storage account file-${share_propery} update --name ${storage_account} --resource-group ${resource_group} ${parameter_name} ${correct_value} --retention-days ${retention_days}" "fix"
        fi
      else
        verbose_message    "az storage account file-${share_propery} update --name ${storage_account} --resource-group ${resource_group} --set ${parameter_name}=${correct_value}" "fix"
      fi
    fi
  fi
}
