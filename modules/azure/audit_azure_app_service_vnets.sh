#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_vnets
#
# Check Azure App Service VNets
#
# 2.1.19  Ensure configuration is routed through the virtual network integration - TBD
# 2.1.20  Ensure all traffic is routed through the virtual network - TBD
#
# Refer to Section(s) 2.1.19-20 Page(s) 82-86 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_vnets () {
  print_function "audit_azure_app_service_vnets"
  check_message  "Azure App Service VNets"
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
    check_azure_app_service_app_value "VNet Image Pull"    "${app_id}" "${app_name}" "${res_group}" "Microsoft.Web/sites" "vnetRouteAllEnabled"     "eq" "true" "properties.vnetRouteAllEnabled"     ""
    check_azure_app_service_app_value "VNet Content Share" "${app_id}" "${app_name}" "${res_group}" "Microsoft.Web/sites" "vnetContentShareEnabled" "eq" "true" "properties.vnetContentShareEnabled" ""
  done
}
