#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_plans
#
# Check Azure App Service Plans
#
# 2.1.15  Ensure App Service plan SKU supports private endpoints - TBD
#
# Refer to Section(s) 2.1.15 Page(s) 69-72 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_plans () {
  print_function "audit_azure_app_service_plans"
  check_message  "Azure App Service Plans"
  command="az webapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No App Services found"
    return
  fi
  for app_id in ${app_ids}; do
    command="az webapp show --id \"${app_id}\" --query \"appServicePlanId\" --output tsv"
    command_message   "${command}"
    app_plans=$( eval "${command}" )
    command="az webapp show --id \"${app_id}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    if [ -z "${app_plans}" ]; then
      info_message "No App Service Plans found"
      return
    fi
    for app_plan in ${app_plans}; do
      check_azure_app_service_plan_value "${app_plan}" "${res_group}" "sku.tier" "eq" "${azure_sku_tier}" "--sku" ""
    done
  done
}
