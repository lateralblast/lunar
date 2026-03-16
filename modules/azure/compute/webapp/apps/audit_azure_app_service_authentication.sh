#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_authentication
#
# Check Azure App Service Authentication
#
# 2.1.12  Ensure 'App Service authentication' is set to 'Enabled' - TBD
#
# Refer to Section(s) 2.1.12 Page(s) 60-2 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_authentication () {
  print_function "audit_azure_app_service_authentication"
  check_message  "Azure App Service Authentication"
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
    check_azure_app_service_app_value "App Service Auth v1" "${app_id}" "${app_name}" "${res_group}" "auth" "enabled"          "eq" "true" "--enabled" ""
    check_azure_app_service_app_value "App Service Auth v2" "${app_id}" "${app_name}" "${res_group}" "auth" "platform.enabled" "eq" "true" "--enabled" ""
  done
}
