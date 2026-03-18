#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_deployment_slots_cross_origin_resource_sharing
#
# 2.4.15  Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2.4.15 Page(s) 232-4 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_deployment_slots_cross_origin_resource_sharing () {
  print_function "audit_azure_function_deployment_slots_cross_origin_resource_sharing"
  check_message  "Azure Function App Deployment Slots Cross-Origin Resource Sharing"
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
      check_azure_function_deployment_slot_value "Cross-Origin Resource Sharing" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "cors" "siteConfig.cors.allowedOrigins" "ne" "*" "properties.cors.allowedOrigins" ""
    done
  done
}
