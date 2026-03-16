#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_basic_authentication_publishing_credential_values
#
# Check Azure App Service Basic Authentication Publishing Credential Values
#
# 2.1.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
#
# Refer to Section(s) 2.1.4 Page(s) 35-8 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_basic_authentication_publishing_credential_values () {
  print_function "audit_azure_app_service_basic_authentication_publishing_credential_values"
  check_message  "Azure App Service Basic Authentication Publishing Credential Values"
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
    check_azure_basic_authentication_publishing_credential_value "${app_name}" "${res_group}" "ftp" "Microsoft.Web" "basicPublishingCredentialsPolicies" "properties.allow" "eq" "false" "--auth-settings.publishing-credentials-enabled" ""
    check_azure_basic_authentication_publishing_credential_value "${app_name}" "${res_group}" "scm" "Microsoft.Web" "basicPublishingCredentialsPolicies" "properties.allow" "eq" "false" "--auth-settings.publishing-credentials-enabled" ""
  done
}
