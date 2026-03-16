#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_deployment_slots_virtual_network_integration
#
# 2.2.14  Ensure app is integrated with a virtual network - TBD
# 2.2.15  Ensure configuration is routed through the virtual network integration - TBD
#
# Refer to Section(s) 2.2.14-5 Page(s) 131-5 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_deployment_slots_virtual_network_integration () {
  print_function "audit_azure_app_service_deployment_slots_virtual_network_integration"
  check_message  "Azure App Service Deployment Slot Virtual Network Integration"
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
      check_azure_app_service_deployment_slot_value "Virtual Network Integration" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "virtualNetworkSubnetId"  "ne" ""     ""                                   ""
      check_azure_app_service_deployment_slot_value "VNet Image Pull"             "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "vnetRouteAllEnabled"     "eq" "true" "properties.vnetRouteAllEnabled"     ""
      check_azure_app_service_deployment_slot_value "VNet Content Share"          "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "vnetContentShareEnabled" "eq" "true" "properties.vnetContentShareEnabled" ""
    done
  done
}
