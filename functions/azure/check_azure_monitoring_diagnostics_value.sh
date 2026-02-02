#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_monitoring_diagnostics_value
#
# Check Azure Monitoring Diagnostics Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_monitoring_diagnostics_value () {
  resource_id="${1}"
  command="az monitor diagnostic-settings list --resource \"${resource_id}\" --output tsv"
  command_message "${command}"
  stderr=$( { stdout=$( az monitor diagnostic-settings list --resource ${resource_id} --output tsv ); } 2>&1 )
  if [ -n "${stderr}" ]; then
    stderr=$( echo "${stderr}" | tr "\n" " " | cut -f2 -d: | cut -f3-11 -d" " )
    verbose_message "${stderr}" "notice"
  else
    if [ -n "${stdout}" ]; then
      increment_secure   "Resource logging is enabled for ${resource_id}"
    else
      increment_insecure "Resource logging is not enabled for ${resource_id}"
    fi
  fi
}
