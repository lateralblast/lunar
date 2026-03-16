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
  print_function "check_azure_storage_logging_value"
  short_service=$( echo "${service_type}" | cut -c 1 )
  check_message  "${description} for \"${file_system}\" for Storage Account \"${storage_account}\" has Parameter \"${query_string}\" \"${function}\" to \"${correct_value}\""
  command="az storage logging show --services ${short_service} --account-name \"${storage_account}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
      if [ ! "${log_value}" = "" ]; then
        fix_message "az storage logging update --account-name ${storage_account} --services ${short_service} --log ${log_value} --retention ${correct_value}"
      fi
    fi
  elif [ "${function}" = "ne" ]; then
    if [ "${actual_value}" != "${correct_value}" ]; then
      inc_secure   "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
    fi
  fi
}
