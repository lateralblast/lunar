#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_blob_value
#
# Check Azure Storage Blob value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_blob_value () {
  print_function  "check_azure_storage_account_value"
  description="${1}"
  storage_account="${2}"
  container_name="${3}"
  blob_name="${4}"
  parameter_name="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  verbose_message "${description} for Storage Blob \"${blob_name}\" on account \"${storage_account}\" in container \"${container_name}\" is \"${function} to \"${correct_value}\"" "check"
  if [ "${azure_auth_mode}" = "login" ]; then
    command="az storage blob ${blob_property} ${blob_policy} show --account-name \"${storage_account}\" --query \"${parameter_name}\" --output tsv --auth-mode \"${azure_auth_mode}\" 2> /dev/null"
    command_message "${command}"
    actual_value=$( eval "${command}" )
  else
    command="az storage blob ${blob_property} ${blob_policy} show --account-name \"${storage_account}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
    command_message "${command}"
    actual_value=$( eval "${command}" )
  fi
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "${description} for Storage Blob \"${blob_name}\" on account \"${storage_account}\" in container \"${container_name}\" is \"${function}\" to \"${correct_value}\""
  else
    increment_insecure "${description} for Storage Blob \"${blob_name}\" on account \"${storage_account}\" in container \"${container_name}\" is not \"${function}\" to \"${correct_value}\""
    if [ ! -z "${set_name}" ]; then
      case "${set_name}" in
        "--"*)
          verbose_message    "az storage blob ${blob_property} ${blob_policy} update --name ${storage_account} ${set_name} ${correct_value}" "fix"
          ;;
        *)
          verbose_message    "az storage blob ${blob_property} ${blob_policy} update --name ${storage_account} --set ${set_name}=${correct_value}" "fix"
          ;;
      esac
    fi
  fi
}
