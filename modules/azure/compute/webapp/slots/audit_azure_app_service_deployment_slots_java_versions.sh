#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_deployment_slots_java_versions
#
# 2.2.1   Ensure 'Java version' is currently supported (if in use) - TBD
#
# Refer to Section(s) 2.2.1 Page(s) 91-93 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_deployment_slots_java_versions () {
  print_function "audit_azure_app_service_deployment_slots_java_versions"
  check_message  "Azure App Service Deployment Slot Java Versions"
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
      check_azure_app_service_deployment_slot_value "Java Version"           "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "javaVersion"          "eq" "${azure_java_version}" "--java-version"           ""
      check_azure_app_service_deployment_slot_value "Java Container Version" "${slot_id}" "${app_name}" "${res_group}" "config" "web" "Microsoft.Web/sites" "javaContainerVersion" "eq" "${azure_java_version}" "--java-container-version" ""
    done
  done
}
