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
  query_string="${5}"
  function="${6}"
  correct_value="${7}"
  parameter_name="${8}"
  print_function  "check_azure_monitor_value"
  verbose_message "Azure Monitor value" "check"
  if [ "${query_string}" = "" ]; then
    parameter_string=""
  else
    parameter_string=" and parameter \"${query_string}\""
  fi
  actual_value=$( az monitor "${monitor_property}" show --name "${workspace_name}" --resource-id "${resource_id}" --query "${query_string}" --output tsv 2> /dev/null )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} has a value of \"${correct_value}\""
    else
      increment_insecure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} does not have a value of \"${correct_value}\""
      if [ ! "${query_string}" = "" ]; then
        verbose_message "az monitor log-analytics workspace update --name \"${workspace_name}\" --resource-id \"${resource_id}\" --query \"${query_string}\" --output tsv" "fix"
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} has a value of \"${correct_value}\""
      if [ ! "${query_string}" = "" ]; then
        verbose_message "az monitor log-analytics workspace update --name \"${workspace_name}\" --resource-id \"${resource_id}\" --query \"${query_string}\" --output tsv" "fix"
      fi
    else
      increment_secure "${description} for workspace \"${workspace_name}\" with Resource ID \"${resource_id}\"${parameter_string} has a value of \"${correct_value}\""
    fi
  fi
}
