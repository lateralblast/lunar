#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_java_versions
#
# 2.3.1   Ensure 'Java version' is currently supported (if in use) - TBD
#
# Refer to Section(s) 2.3.1 Page(s) 143-5 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_java_versions () {
  print_function "audit_azure_function_app_java_versions"
  check_message  "Azure Function Apps Java Versions"
  command="az functionapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No Function Apps found"
    return
  fi
  for app_id in ${app_ids}; do
    command="az functionapp show --name \"${app_name}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    check_azure_app_service_deployment_slot_value "Java Version"           "${app_id}" "${res_group}" "config" "web" "" "javaVersion"          "eq" "${azure_java_version}" "--java-version"           ""
    check_azure_app_service_deployment_slot_value "Java Container Version" "${app_id}" "${res_group}" "config" "web" "" "javaContainerVersion" "eq" "${azure_java_version}" "--java-container-version" ""
  done
}
