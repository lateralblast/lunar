#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_function_deployment_ftp_states
#
# 2.4.4   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
#
# Refer to Section(s) 2.4.4 Page(s) 203-4 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_function_deployment_ftp_states () {
  print_function "audit_azure_function_deployment_ftp_states"
  check_message  "Azure Function App Deployment Slots FTP States"
  command="az functionapp list --query \"[].id\" --output tsv"
  command_message "${command}"
  app_ids=$( eval "${command}" 2> /dev/null )
  if [ -z "${app_ids}" ]; then
    info_message "No Function App Apps found"
    return
  fi
  for app_id in ${app_ids}; do
    command="az functionapp show --name \"${app_id}\" --query \"name\" --output tsv"
    command_message   "${command}"
    app_name=$( eval  "${command}" )
    command="az functionapp show --name \"${app_id}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    command="az functionapp deployment slot list --name \"${app_id}\" --query \"[].id\" --output tsv"
    command_message   "${command}"
    slot_ids=$( eval  "${command}" 2> /dev/null )
    if [ -z "${slot_ids}" ]; then
      info_message "No Function App Deployment Slots found"
      return
    fi
    for slot_id in ${slot_ids}; do
      check_azure_function_deployment_slot_value "FTP State" "${slot_id}" "${app_name}" "${res_group}" "config" "ftp" "Microsoft.Web/sites" "ftpState" "eq" "${azure_ftp_state}" "--ftp-state" ""
    done
  done
}
