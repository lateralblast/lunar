#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_client_certificates
#
# Check Azure App Service Client Certificates
#
# 2.1.11  Ensure incoming client certificates are enabled and required (if in use) - TBD
#
# Refer to Section(s) 2.1.11 Page(s) 57-59 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_client_certificates () {
  print_function "audit_azure_app_service_client_certificates"
  check_message  "Azure App Service Client Certificates"
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
    check_azure_app_service_app_value "Client Certificates" "${app_id}" "${app_name}" "${res_group}" "Microsoft.Web/sites" "clientCertEnabled" "eq" "true" "clientCertEnabled" ""
  done
}
