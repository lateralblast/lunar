#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_storage_account_keys_rotation
#
# Check Azure Storage Account Keys Rotation
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_storage_account_keys_rotation () {
  storage_account="${1}"
  resource_id="${2}"
  correct_value="${3}"
  command="az monitor activity-log list --namespace Microsoft.Storage --offset ${correct_value}d --query \"[?contains(authorization.action, 'regenerateKey')]\" --resource-id \"${resource_id}\" 2> /dev/null |grep \"Succeeded\""
  status_check=$( eval "${command}" )
  command_message "${command}" "exec"
  if [ -n "${status_check}" ]; then
    increment_secure "Storage Account \"${storage_account}\" has access keys regenerated in the last \"${correct_value}\" days"
  else
    creation_date=$( az storage account show --name "${storage_account}" --query "creationTime" --output tsv | cut -d T -f 1 )
    if [ "${os_name}" = "Linux" ]; then
      creation_secs=$( date -d "${creation_date}" +%s )
      current_secs=$( date +%s )
    else 
      if [ "${os_name}" = "Darwin" ]; then
        creation_secs=$( date -j -f "%Y-%m-%d" "${creation_date}" +%s )
        current_secs=$( date +%s )
      fi
    fi
    diff_secs=$(( current_secs - creation_secs ))
    diff_days=$(( diff_secs / 86400 ))
    if [ ${diff_days} -le ${correct_value}  ]; then
      increment_secure   "Storage Account \"${storage_account}\" has access keys generated in the last \"${correct_value}\" days"
    else
      increment_insecure "Storage Account \"${storage_account}\" does not have access keys regenerated in the last \"${correct_value}\" days"
    fi
  fi
}
