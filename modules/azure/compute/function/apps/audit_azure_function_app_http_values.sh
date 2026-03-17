#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_http_values
#
# 2.3.5   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.3.6   Ensure 'HTTPS Only' is set to 'On' - TBD
#
# Refer to Section(s) 2.3.5-6 Page(s) 155-60 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_http_values () {
  print_function "audit_azure_function_app_http_values"
  check_message  "Azure Function Apps HTTP Values"
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
    check_azure_function_app_value "HTTP Version" "${app_id}" "${res_group}" "config" "web" "" "http20Enabled" "eq" "true" "--http20-enabled" ""
    check_azure_function_app_value "HTTPS Only"   "${app_id}" "${res_group}" "config" "web" "" "httpsOnly"     "eq" "true" "httpsOnly"        ""
  done
}
