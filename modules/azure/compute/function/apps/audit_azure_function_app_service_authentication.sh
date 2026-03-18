#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_service_authentication
#
# 2.3.11 Ensure 'App Service authentication' is set to 'Enabled' - TBD
#
# Refer to Section(s) 2.3.11 Page(s) 172-4 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_service_authentication () {
  print_function "audit_azure_function_app_service_authentication"
  check_message  "Azure Function Apps Service Authentication"
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
    check_azure_function_app_value "App Service Authentication" "${app_id}" "${res_group}" "auth" "web" "Microsoft.Web/sites" "authSettings.enabled" "eq" "true" "properties.authSettings.enabled" ""
  done
}
