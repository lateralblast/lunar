#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_databricks_values
#
# Check Azure Databricks values
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_databricks_values () {
  description="$1"
  workspace_name="$2"
  resource_group="$3"
  query_string="$4"
  function="$5"
  correct_value="$6"
  parameter_name="$7"
  print_function  "check_azure_databricks_values"
  verbose_message "Azure Databricks values" "check"
  actual_value=$( az databricks workspace show --name "${workspace_name}" --resource-group "${resource_group}" --query "${query_string}" -o tsv )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" has a value of \"${correct_value}\""
    else
      increment_insecure "${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" does not have a value of \"${correct_value}\""
      if [ ! "${parameter_name}" = "" ]; then
        verbose_message "az databricks workspace update --name \"${workspace_name}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" -o tsv" "fix"
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" has a value of \"${correct_value}\""
      if [ ! "${parameter_name}" = "" ]; then
        verbose_message "az databricks workspace update --name \"${workspace_name}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" -o tsv" "fix"
      fi
    else
      increment_secure "${description} for workspace \"${workspace_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" does not have a value of \"${correct_value}\""
    fi
  fi
}
