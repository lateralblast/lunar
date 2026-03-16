#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_deployment_slots_private_endpoints
#
# 2.2.16  Ensure private endpoints are used to access App Service apps - TBD
#
# Refer to Section(s) 2.2.16 Page(s) 136-8 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_deployment_slots_private_endpoints () {
  print_function "audit_azure_app_service_deployment_slots_private_endpoints"
  check_message  "Azure App Service Deployment Slot Private Endpoints"
  command="az webapp list --query \"[].id\" --output tsv"
  command_message   "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No App Service Deployment Slots found"
    return
  fi
  command="az webapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  for app_id in ${app_ids}; do
    check_azure_network_private_endpoint_value "${app_id}" "[*].privateLinkServiceConnections[*].[privateLinkServiceId,privateLinkServiceConnectionState.status]" "eq" "Approved"
  done
}
