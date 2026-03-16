#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_deployment_slot_http_versions
#
# 2.2.6   Ensure 'HTTP version' is set to '2.0' (if in use) - TBD
# 2.2.7   Ensure 'HTTPS Only' is set to 'On' - TBD
#
# Refer to Section(s) 2.2.6 Page(s) 107-12 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_deployment_slot_http_versions () {
  print_function "audit_azure_app_service_deployment_slot_http_versions"
  check_message  "Azure App Service Deployment Slot HTTP Versions"
  command="az webapp list --query \"[].id\" --output tsv"
  command_message   "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No App Service Deployment Slots found"
    return
  fi
  for app_id in ${app_ids}; do
    command="az webapp show --id \"${app_id}\" --query \"name\" --output tsv"
    command_message   "${command}"
    app_name=$( eval  "${command}" )
    command="az webapp show --id \"${app_id}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    command="az webapp deployment slot list --id \"${app_id}\" --query \"[].id\" --output tsv"
    command_message   "${command}"
    slot_ids=$( eval  "${command}" 2> /dev/null )
    if [ -z "${slot_ids}" ]; then
      info_message "No App Service Deployment Slots found"
      return
    fi
    for slot_id in ${slot_ids}; do
      check_azure_app_service_deployment_slot_value "HTTP Version" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "http20Enabled" "eq" "true" "--http20-enabled" ""
      check_azure_app_service_deployment_slot_value "HTTPS Only"   "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "httpsOnly"     "eq" "true" "httpsOnly"        ""
    done
  done
}
