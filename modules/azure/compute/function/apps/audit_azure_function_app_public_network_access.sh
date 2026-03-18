#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_public_network_access
#
# 2.3.13  Ensure public network access is disabled - TBD
#
# Refer to Section(s) 2.3.13 Page(s) 178-80 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_public_network_access () {
  print_function "audit_azure_function_app_public_network_access"
  check_message  "Azure Function Apps Public Network Access"
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
    check_azure_function_app_value "Public Network Access" "${app_id}" "${res_group}" "config" "web" "Microsoft.Web/sites" "publicNetworkAccess" "eq" "Disabled" "properties.publicNetworkAccess" ""
  done
}
