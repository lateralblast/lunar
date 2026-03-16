#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_deployment_slots_tls_values
#
# 2.4.7   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
# 2.4.8   Ensure end-to-end TLS encryption is enabled - TBD
#
# Refer to Section(s) 2.4.7-8 Page(s) 210-217 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_deployment_slots_tls_values () {
  print_function "audit_azure_function_deployment_slots_tls_values"
  check_message  "Azure Function App Deployment Slots TLS Values"
  command="az functionapp list --query \"[].name\" --output tsv"
  command_message   "${command}"
  app_names=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_names}" ]; then
    info_message "No Function App Apps found"
    return
  fi
  for app_id in ${app_ids}; do
    command="az functionapp show --name \"${app_id}\" --query \"name\" --output tsv"
    command_message   "${command}"
    app_name=$( eval  "${command}" )
    command="az functionapp show --name \"${app_id}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    command="az functionapp deployment slot list --name \"${app_id}\" --query \"[].id\" --output tsv"
    command_message   "${command}"
    slot_ids=$( eval  "${command}" 2> /dev/null )
    if [ -z "${slot_ids}" ]; then
      info_message "No Function App Deployment Slots found"
      return
    fi
    for slot_id in ${slot_ids}; do
      check_azure_function_deployment_slot_value "Minimum Inbound TLS Version" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "minTlsVersion"             "eq" "1.2"  "--min-tls-version"                    ""
      check_azure_function_deployment_slot_value "End-to-End TLS Encryption"   "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "endToEndEncryptionEnabled" "eq" "true" "properties.endToEndEncryptionEnabled" ""
    done
  done
}
