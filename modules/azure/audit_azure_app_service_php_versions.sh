#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_php_versions
#
# Check Azure App Service PHP Versions
#
# 2.1.3   Ensure 'PHP version' is currently supported (if in use) - TBD
#
# Refer to Section(s) 2.1.3 Page(s) 32-4 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_php_versions () {
  print_function "audit_azure_app_service_php_versions"
  check_message  "Azure App Service PHP Versions"
  command="az webapp list --query \"[].id\" --output tsv"
  command_message   "${command}"
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
    check_azure_app_service_app_value "PHP Version" "${app_id}" "${app_name}" "${res_group}" "" "phpVersion" "eq" "${azure_php_version}" "--php-version" ""
  done
}
