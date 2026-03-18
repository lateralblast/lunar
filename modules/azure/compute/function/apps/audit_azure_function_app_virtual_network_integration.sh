#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_virtual_network_integration
#
# 2.3.14  Ensure app is integrated with a virtual network - TBD
# 2.3.15  Ensure configuration is routed through the virtual network integration - TBD
# 2.3.16  Ensure all traffic is routed through the virtual network - TBD
#
# Refer to Section(s) 2.3.14, 2.3.15, 2.3.16 Page(s) 181- CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_virtual_network_integration () {
  print_function "audit_azure_function_app_virtual_network_integration"
  check_message  "Azure Function Apps Virtual Network Integration"
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
    check_azure_function_app_value "Virtual Network Integration" "${app_id}" "${res_group}" "config" "web" ""                    "virtualNetworkSubnetId"  "ne" ""     ""                                   ""
    check_azure_function_app_value "VNet Image Pull"             "${app_id}" "${res_group}" "config" "web" "Microsoft.Web/sites" "vnetImagePullEnabled"    "eq" "true" "properties.vnetRouteAllEnabled"     ""
    check_azure_function_app_value "VNet Content Share"          "${app_id}" "${res_group}" "config" "web" "Microsoft.Web/sites" "vnetContentShareEnabled" "eq" "true" "properties.vnetContentShareEnabled" ""
    check_azure_function_app_value "VNet Route All"              "${app_id}" "${res_group}" "config" "web" "Microsoft.Web/sites" "vnetRouteAllEnabled"     "eq" "true" "properties.vnetRouteAllEnabled"     ""
  done
}
