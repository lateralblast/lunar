#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_batch_value
#
# Check Azure Batch value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_batch_value () {
  description="${1}"
  batch_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  set_name="${7}"
  set_value="${8}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  print_function  "check_azure_batch_value"
  verbose_message "${description} for Batch Account \"${batch_name}\" in resource group \"${resource_group}\" has parameter \"${query_string}\" \"${function}\" to \"${correct_value}\"" "check"
  command="az batch account show --name ${batch_name} --resource-group ${resource_group} --query '${query_string}' --output tsv 2> /dev/null"
  command_message "$command"
  actual_value=$(eval "$command")
  if [ "${actual_value}" = "${correct_value}" ]; then
    secure_message "${description} for Batch Account \"${batch_name}\" in resource group \"${resource_group}\" has parameter \"${query_string}\" \"${function}\" to \"${correct_value}\""
  else
    insecure_message "${description} for Batch Account \"${batch_name}\" in resource group \"${resource_group}\" has parameter \"${query_string}\" \"${function}\" to \"${correct_value}\""
    if [ ! "${set_name}" = "" ]; then
      verbose_message  "az batch account set --name \"${batch_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
    fi
  fi
}
