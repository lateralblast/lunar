#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_databox
#
# Check Azure Databox
#
# 12.1 Ensure double encryption is used for Azure Data Box in high-security environments - TBD
#
# Refer to Sections(s) 12 Page(s) 142-3 Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_databox () {
  print_function  "audit_azure_databox"
  verbose_message "Azure Databox" "check"
  command="az databox job list --query '[].id' --output tsv 2> /dev/null"
  command_message "$command"
  job_ids=$(eval "$command")
  if [ -z "${job_ids}" ]; then
    info_message "No Azure Databox job(s) found"
    return
  fi
  for job_id in $job_ids; do
    command="az databox job show --id ${job_id} --query '[].name' --output tsv 2> /dev/null"
    command_message "$command"
    job_name=$(eval "$command")
    command="az databox job show --id ${job_id} --query '[].resourceGroup' --output tsv 2> /dev/null"
    command_message "$command"
    resource_group=$(eval "$command")
    check_azure_databox_value "Double encryption" "${job_name}" "${resource_group}" "DoubleEncryptionEnabled" "eq" "true"
  done
}
