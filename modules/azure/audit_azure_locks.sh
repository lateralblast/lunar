#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_locks
#
# Audit Azure Locks
#
# This requires the Azure CLI to be installed and configured
#

audit_azure_locks () {
  resource_type="${1}"
  lock_type="${2}"
  print_function "audit_azure_locks"
  check_message  "Azure Locks with Resource Type ${resource_type}"
  command="az lock list --query \"[].name\" --resource-type \"${resource_type}\" --output tsv"
  command_message    "${command}"
  lock_names=$( eval "${command}" 2> /dev/null )
  if [ -z "${lock_names}" ]; then
    info_message "No Locks found"
    return
  fi
  for lock_name in ${lock_names}; do
    command="az lock show --name \"${lock_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message        "${command}"
    resource_group=$( eval "${command}" )
    check_azure_lock_value "${lock_name}" "${resource_group}" "${resource_type}" "properties.level" "eq" "${lock_type}" "--lock-type"
  done
}