#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_ftp_states
#
# Check Azure App Service FTP States
#
# 2.1.5   Ensure 'FTP State' is set to 'FTPS only' or 'Disabled' - TBD
#
# Refer to Section(s) 2.1.5 Page(s) 39-41 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_ftp_states () {
  print_function "audit_azure_app_service_ftp_states"
  check_message  "Azure App Service FTP States"
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
    check_azure_app_service_app_value "FTP State" "${app_id}" "${app_name}" "${res_group}" "" "ftpState" "eq" "${azure_ftp_state}" "--ftp-state" ""
  done
}
