#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_app_basic_authentication_publishing_credentials
#
# 2.3.3   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
#
# Refer to Section(s) 2.3.3 Page(s) 149-51 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_app_basic_authentication_publishing_credentials () {
  print_function "audit_azure_function_app_basic_authentication_publishing_credentials"
  check_message  "Azure Function Apps Basic Authentication Publishing Credentials"
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
    check_azure_function_app_value "Basic Authentication Publishing Credentials" "${app_id}" "${res_group}" "basicPublishingCredentialsPolicies" "ftp" "Microsoft.Web" "properties.allow" "eq" "false" "" ""
    check_azure_function_app_value "Basic Authentication Publishing Credentials" "${app_id}" "${res_group}" "basicPublishingCredentialsPolicies" "scm" "Microsoft.Web" "properties.allow" "eq" "false" "" ""
  done
}
