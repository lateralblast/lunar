#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_client_certificates
#
# 2.3.10  Ensure incoming client certificates are enabled and required (if in use) - TBD
#
# Refer to Section(s) 2.3.10 Page(s) 169-70 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_java_versions () {
  print_function "audit_azure_function_app_java_versions"
  check_message  "Azure Function Apps Java Versions"
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
    check_azure_function_app_value "Client Certificates" "${app_id}" "${res_group}" "config" "web" "Microsoft.Web/sites" "clientCertEnabled" "eq" "true" "clientCertEnabled" ""
  done
}
