#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_apps
#
# 2.3.2   Ensure 'Python version' is currently supported (if in use) - TBD
#
# Refer to Section(s) 2.3.2 Page(s) 146-8 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_apps () {
  print_function "audit_azure_functions_apps"
  check_message  "Azure Function Apps"
  command="az functionapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No Function Apps found"
    return
  fi
  for app_id in ${app_ids}; do
    command="az functionapp show --id \"${app_id}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    check_azure_function_app_value "Python Version" "${app_id}" "${res_group}" "config" "web" "" "pythonVersion" "eq" "${azure_python_version}" "--python-version" ""
  done
}
