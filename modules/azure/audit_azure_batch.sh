#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_batch
#
# Check Azure Batch
#
# Refer to Section(s) 15- Page(s) 277- CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_batch () {
  print_function  "audit_azure_batch"
  verbose_message "Azure Batch" "check"
  command="az batch account list --query \"[].name\" --output tsv"
  command_message "${command}"
  batch_list=$( eval "${command}" 2> /dev/null )
  if [ -z "${batch_list}" ]; then
    info_message "No Batch accounts found"
  fi
  for batch_name in ${batch_list}; do
    command="az batch account show --name \"${batch_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    check_azure_batch_value "Private Virtual Networks" "${batch_name}" "${resource_group}" "keyVaultReference" "ne" "" "--encryption-key-identifier" "https://<keyvault_name>.vault.azure.net/keys/<key_name>/<Version>"
  done
}
