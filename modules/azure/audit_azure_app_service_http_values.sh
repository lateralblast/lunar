#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_http_values
#
# Check Azure App Service HTTP Values
#
# 2.1.6   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.1.7   Ensure 'HTTPS Only' is set to 'On' - TBD
#
# Refer to Section(s) 2.1.6-7 Page(s) 42-7 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_http_values () {
  print_function "audit_azure_app_service_http_values"
  check_message  "Azure App Service HTTP Values"
  command="az webapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No App Services found"
    return
  fi
  for app_id in ${app_ids}; do
    command="az webapp show --id \"${app_id}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    command="az webapp show --id \"${app_id}\" --query \"name\" --output tsv"
    command_message   "${command}"
    app_name=$( eval  "${command}" )
    check_azure_app_service_app_value "HTTP Version" "${app_id}" "${app_name}" "${res_group}" "" "http20Enabled" "eq" "true" "--http20-enabled" ""
    check_azure_app_service_app_value "HTTPS Only"   "${app_id}" "${app_name}" "${res_group}" "" "httpsOnly"     "eq" "true" "httpsOnly"        ""
  done
}
