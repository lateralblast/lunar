#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_fs_value
#
# Check Azure Storage File System Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_fs_value () {
  description="${1}"
  storage_account="${2}"
  file_system="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"  
  print_function  "check_azure_storage_fs_value"
  verbose_message "${description} for File System \"${file_system}\" for Storage Account \"${storage_account}\" has Parameter \"${query_string}\" \"${function}\" to \"${correct_value}\"" "check"
  command="az storage fs show --account-name \"${storage_account}\" --name \"${file_system}\" --query \"${query_string}\" --auth-mode \"${azure_auth_mode}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
    fi
  elif [ "${function}" = "ne" ]; then
    if [ "${actual_value}" != "${correct_value}" ]; then
      increment_secure   "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for File System \"${file_system}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
    fi
  fi
}