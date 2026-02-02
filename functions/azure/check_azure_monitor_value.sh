#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_monitor_value
#
# Check Azure Monitor values
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_monitor_value () {
  description="${1}"
  workspace_name="${2}"
  resource_id="${3}"
  monitor_property="${4}"
  parameter_name="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  print_function  "check_azure_monitor_value"
  if [ "${parameter_name}" = "" ]; then
    parameter_string=""
  else
    parameter_string=" and parameter \"${parameter_name}\""
  fi
  verbose_message "Azure Monitor value for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} is \"${function}\" to \"${correct_value}\"" "check"
  command="az monitor "${monitor_property}" show --name "${workspace_name}" --resource-id "${resource_id}" --query "${parameter_name}" --output tsv 2> /dev/null"
  actual_value=$( eval "${command}" )
  command_message "${command}"
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} is not \"${function}\" to \"${correct_value}\""
      if [ ! "${parameter_name}" = "" ]; then
        verbose_message "az monitor log-analytics workspace update --name \"${workspace_name}\" --resource-id \"${resource_id}\" --query \"${parameter_name}\" --output tsv" "fix"
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} is not \"${function}\" to \"${correct_value}\""
      if [ ! "${parameter_name}" = "" ]; then
        verbose_message "az monitor log-analytics workspace update --name \"${workspace_name}\" --resource-id \"${resource_id}\" --query \"${parameter_name}\" --output tsv" "fix"
      fi
    else
      increment_secure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
