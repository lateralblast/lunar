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
  description="${1}"
  storage_account="${2}"
  container_name="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  print_function  "check_azure_storage_container_value"
  verbose_message "${description} for Storage Container \"${container_name}\" for Storage Account \"${storage_account}\" has Parameter \"${query_string}\" \"${function}\" to \"${correct_value}\"" "check"
  command="az storage container show --account-name \"${storage_account}\" --name \"${container_name}\" --query \"${query_string}\" --auth-mode login --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${description} for Storage Container \"${container_name}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for Storage Container \"${container_name}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
    fi
  elif [ "${function}" = "ne" ]; then
    if [ "${actual_value}" != "${correct_value}" ]; then
      increment_secure   "${description} for Storage Container \"${container_name}\" on Storage Account \"${storage_account}\" has \"${query_string}\" \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for Storage Container \"${container_name}\" on Storage Account \"${storage_account}\" does not have \"${query_string}\" \"${function}\" to \"${correct_value}\""
    fi
  fi
}
