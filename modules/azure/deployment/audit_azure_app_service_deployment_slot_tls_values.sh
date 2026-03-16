#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_deployment_slot_tls_values
#
# 2.2.8   Ensure 'Minimum Inbound TLS Version' is set to '1.2' or higher - TBD
#
# Refer to Section(s) 2.2.8 Page(s) 113-8 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_deployment_slot_tls_values () {
  print_function "audit_azure_app_service_deployment_slot_tls_values"
  check_message  "Azure App Service Deployment Slot TLS Values"
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
      check_azure_app_service_deployment_slot_value "Minimum Inbound TLS Version" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "minTlsVersion"             "eq" "1.2"  "--min-tls-version"                    ""
      check_azure_app_service_deployment_slot_value "End-to-End TLS Encryption"   "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "endToEndEncryptionEnabled" "eq" "true" "properties.endToEndEncryptionEnabled" ""
    done
  done
}
