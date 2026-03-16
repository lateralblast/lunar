#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_deployment_slots_managed_identities
#
# 2.4.11  Ensure managed identities are configured - TBD
#
# Refer to Section(s) 2.4.11 Page(s) 222-4 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_deployment_slots_managed_identities () {
  print_function "audit_azure_function_deployment_slots_managed_identities"
  check_message  "Azure Function App Deployment Slots Managed Identities"
  command="az functionapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
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
      check_azure_function_deployment_slot_value "Managed Identities" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "identity" "type" "eq" "${azure_managed_identity}" "" ""
    done
  done
}
