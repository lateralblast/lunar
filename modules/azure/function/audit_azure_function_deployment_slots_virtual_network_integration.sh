#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_deployment_slots_virtual_network_integration
#
# 2.4.13  Ensure app is integrated with a virtual network - TBD
# 2.4.14  Ensure configuration is routed through the virtual network integration - TBD
#
# Refer to Section(s) 2.4.13-4 Page(s) 228-31 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_deployment_slots_virtual_network_integration () {
  print_function "audit_azure_function_deployment_slots_virtual_network_integration"
  check_message  "Azure Function App Deployment Slots Virtual Network Integration"
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
      check_azure_function_deployment_slot_value "Virtual Network Integration" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "virtualNetworkSubnetId"  "ne" ""     ""                                   ""
      check_azure_function_deployment_slot_value "VNet Image Pull"             "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "vnetRouteAllEnabled"     "eq" "true" "properties.vnetRouteAllEnabled"     ""
      check_azure_function_deployment_slot_value "VNet Content Share"          "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "vnetContentShareEnabled" "eq" "true" "properties.vnetContentShareEnabled" ""
    done
  done
}
