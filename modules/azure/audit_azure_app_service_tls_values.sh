#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_tls_values
#
# Check Azure App Service TLS Values
#
# 2.1.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.1.9   Ensure end-to-end TLS encryption is enabled - TBD
#
# Refer to Section(s) 2.1.8-9 Page(s) 48-53 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_tls_values () {
  print_function "audit_azure_app_service_tls_values"
  check_message  "Azure App Service TLS Values"
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
    check_azure_app_service_app_value "Minimum Inbound TLS Version" "${app_id}" "${app_name}" "${res_group}" ""                    "minTlsVersion"             "eq" "1.2"  "--min-tls-version"                    ""
    check_azure_app_service_app_value "End-to-End TLS Encryption"   "${app_id}" "${app_name}" "${res_group}" "Microsoft.Web/sites" "endToEndEncryptionEnabled" "eq" "true" "properties.endToEndEncryptionEnabled" ""
  done
}
