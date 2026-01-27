#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_blob_value
#
# Check Azure Storage Blob Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_blob_value () {
  print_function  "check_azure_storage_account_value"
  description="${1}"
  storage_account="${2}"
  blob_propery="${3}"
  blob_policy="${4}"
  query_string="${5}"
  function="${6}"
  correct_value="${7}"
  parameter_name="${8}"
  verbose_message "${description} for Storage Blobs on account \"${storage_account}\" is \"${correct_value}\"" "check"
  if [ "${azure_auth_mode}" = "login" ]; then
    actual_value=$( az storage blob ${blob_propery} ${blob_policy} show --account-name "${storage_account}" --query "${query_string}" --output tsv --auth-mode "${azure_auth_mode}" )
  else
    actual_value=$( az storage blob ${blob_propery} ${blob_policy} show --account-name "${storage_account}" --query "${query_string}" --output tsv )
  fi
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "Storage Blob \"${storage_account}\" has ${description} set to ${correct_value}"
  else
    increment_insecure "Storage Blob \"${storage_account}\" does not have ${description} set to ${correct_value}"
    if [ ! -z "${parameter_name}" ]; then
      if [[ ${parameter_name} =~ -- ]]; then
        verbose_message    "az storage blob ${blob_propery} ${blob_policy} update --name ${storage_account} ${parameter_name} ${correct_value}" "fix"
      else
        verbose_message    "az storage blob ${blob_propery} ${blob_policy} update --name ${storage_account} --set ${parameter_name}=${correct_value}" "fix"
      fi
    fi
  fi
}
