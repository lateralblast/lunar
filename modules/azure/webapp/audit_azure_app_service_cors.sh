#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_cors
#
# Check Azure App Service Cross-origin Resource sharing
#
# 2.1.21  Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2.1.21 Page(s) 87-9 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_cors () {
  print_function "audit_azure_app_service_cors"
  check_message  "Azure App Service Cross-origin Resource Sharing"
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
    check_azure_app_service_app_value "Cross-Origin Resource Sharing" "${app_id}" "${app_name}" "${res_group}" "cors" "siteConfig.cors.allowedOrigins" "ne" "*" "properties.cors.allowedOrigins" ""
  done
}
