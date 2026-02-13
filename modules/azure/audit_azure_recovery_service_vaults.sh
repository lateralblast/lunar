#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_recovery_service_vaults
#
# Check Azure Recovery Service Vaults
#
# 2.2.1.1 Ensure public network access is Disabled
#
# Refer to Section(s) 2 Page(s) 25- CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_recovery_service_vaults () {
  print_function  "audit_azure_recovery_service_vaults"
  verbose_message "Azure Recovery Service Vaults" "check"
  command="az resource list --resource-type Microsoft.RecoveryServices/vaults --query \"[].id\" --output tsv"
  command_message "${command}"
  vault_ids=$( eval "${command}" )
  for vault_id in ${vault_ids}; do
    command="az resource show --id \"${vault_id}\" --query \"resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    command="az resource show --id \"${vault_id}\" --query \"name\" --output tsv"
    command_message "${command}"
    vault_name=$( eval "${command}" )
    check_azure_backup_vault_value "Public Network Access" "${vault_name}" "${resource_group}" "properties.publicNetworkAccess" "eq" "Disabled" "--public-network-access"
  done
}
