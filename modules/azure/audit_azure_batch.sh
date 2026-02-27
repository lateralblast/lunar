#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_batch
#
# Check Azure Batch
#
# 15.1 Ensure Batch account is set to use customer-managed keys to encrypt data 
# 15.2 Ensure Batch pools disk encryption is set enabled
# 15.3 Ensure local authentication methods for accounts are disabled
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
    check_azure_batch_value "Customer Managed Keys"        "${batch_name}" "${resource_group}" "keyVaultReference"          "ne" ""    "--encryption-key-identifier" "https://<keyvault_name>.vault.azure.net/keys/<key_name>/<Version>"
    check_azure_batch_value "Local Authentication Methods" "${batch_name}" "${resource_group}" "allowedAuthenticationModes" "eq" "AAD" ""                            ""
    command="az batch pool list --account-name \"${batch_name}\" --query \"[].id\" --output tsv"
    command_message "${command}"
    pool_ids=$( eval "${command}" )
    for pool_id in ${pool_ids}; do
      for disk_name in OsDisk TemporaryDisk; do
        check_azure_batch_pool_value "Batch pools disk encryption" "${pool_id}" "deploymentConfiguration.virtualMachineConfiguration.diskEncryption.Configuration.encryption.targets" "has" "${disk_name}"
      done
    done
  done
}
