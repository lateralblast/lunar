#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_tls_values
#
# 2.3.7   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.3.8   Ensure end-to-end TLS encryption is enabled - TBD
#
# Refer to Section(s) 2.3.7-8 Page(s) 155-156 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_tls_values () {
  print_function "audit_azure_function_app_tls_values"
  check_message  "Azure Function Apps TLS Values"
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
    check_azure_function_app_value "Minimum Inbound TLS Version" "${app_id}" "${res_group}" "config" "web" ""                    "minTlsVersion"             "eq" "1.2"                           "--min-tls-version"                              ""
    check_azure_function_app_value "End-to-End TLS Encryption"   "${app_id}" "${res_group}" "config" "web" "Microsoft.Web/sites" "endToEndEncryptionEnabled" "eq" "true"                          "properties.endToEndEncryptionEnabled"           ""
  done
}
