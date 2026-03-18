#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_cross_origin_resource_sharing
#
# 2.3.17  Ensure cross-origin resource sharing does not allow all origins - TBD
#
# Refer to Section(s) 2.3.17 Page(s) 143-5 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_cross_origin_resource_sharing () {
  print_function "audit_azure_function_app_cross_origin_resource_sharing"
  check_message  "Azure Function Apps Cross-Origin Resource Sharing"
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
    check_azure_function_app_value "Cross-Origin Resource Sharing" "${app_id}" "${res_group}" "config" "web" "cors" "siteConfig.cors.allowedOrigins" "ne" "*" "properties.cors.allowedOrigins" ""
  done
}
