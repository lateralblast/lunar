#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_logging_value
#
# Check Azure Storage Logging value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_logging_value () {
  description="${1}"
  storage_account="${2}"
  service_type="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  log_value="${7}"
  short_service=$( echo "${service_type}" | cut -c 1 )
  print_function  "check_azure_storage_logging_value"
  verbose_message "${description} for \"${file_system}\" for Storage Account \"${storage_account}\" has Parameter \"${query_string}\" \"${function}\" to \"${correct_value}\"" "check"
  command="az storage logging show --services ${short_service} --account-name \"${storage_account}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
      if [ ! "${log_value}" = "" ]; then
        verbose_message "az storage logging update --account-name ${storage_account} --services ${short_service} --log ${log_value} --retention ${correct_value}" "fix" 
      fi
    fi
  elif [ "${function}" = "ne" ]; then
    if [ "${actual_value}" != "${correct_value}" ]; then
      increment_secure   "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
    fi
  fi
}
