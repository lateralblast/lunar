#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_deployment_slot_basic_authentication_publishing_credentials
#
# 2.2.4   Ensure 'Basic Authentication Publishing Credentials' are 'Disabled' - TBD
#
# Refer to Section(s) 2.2.4 Page(s) 100-3 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_deployment_slot_basic_authentication_publishing_credentials () {
  print_function "audit_azure_app_service_deployment_slot_basic_authentication_publishing_credentials"
  check_message  "Azure App Service Deployment Slot Basic Authentication Publishing Credentials"
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
      check_azure_app_service_deployment_slot_value "Basic Authentication Publishing Credentials" "${slot_id}" "${app_name}" "${res_group}" "basicPublishingCredentialsPolicies" "ftp" "Microsoft.Web/sites" "properties.allow" "eq" "false" "" ""
      check_azure_app_service_deployment_slot_value "Basic Authentication Publishing Credentials" "${slot_id}" "${app_name}" "${res_group}" "basicPublishingCredentialsPolicies" "scm" "Microsoft.Web/sites" "properties.allow" "eq" "false" "" ""
    done
  done
}
