#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_backup_vaults
#
# Check Azure Backup Vaults
#
# 5.1.1 Ensure soft delete on Backup vaults is Enabled
# 5.1.2 Ensure immutability for Backup vaults is Enabled
# 5.1.3 Ensure backup data in Backup vaults is encrypted using customer-managed keys (CMK)
# 5.1.4 Ensure 'Use infrastructure encryption for this vault' is enabled on Backup vaults
# 5.1.5 Ensure 'Cross Region Restore' is set to 'Enabled' on Backup vaults
#
# Refer to Section(s) 2 Page(s) 25- CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_backup_vaults () {
  print_function  "audit_azure_backup_vaults"
  verbose_message "Azure Backup Vaults" "check"
  immutability_state="Locked"
  retention_days="90"
  command="az backup vault list --query \"[].id\" --output tsv"
  command_message "${command}"
  vault_ids=$( eval "${command}" )
  for vault_id in ${vault_ids}; do
    command="az backup vault show --id \"${vault_id}\" --query \"resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    command="az backup vault show --id \"${vault_id}\" --query \"name\" --output tsv"
    command_message "${command}"
    vault_name=$( eval "${command}" )
    # 5.1.1 Ensure soft delete on Backup vaults is Enabled
    check_azure_backup_vault_value "Soft Delete"               "${vault_name}" "${resource_group}" "properties.encryption.keyUri"      "ne" ""        ""
    # 5.1.3 Ensure backup data in Backup vaults is encrypted using customer-managed keys (CMK)  
    check_azure_backup_vault_value "Customer Managed Keys"     "${vault_name}" "${resource_group}" "properties.softDeleteFeatureState"          "eq" "Enabled" "properties.softDeleteFeatureState"
    # 5.1.4 Ensure 'Use infrastructure encryption for this vault' is enabled on Backup vaults
    check_azure_backup_vault_value "Infrastructure Encryption" "${vault_name}" "${resource_group}" "properties.infrastructureEncryptionEnabled" "eq" "true"    "--infrastructure-encryption-enabled"
    # 5.1.5 Ensure 'Cross Region Restore' is set to 'Enabled' on Backup vaults
    check_azure_backup_vault_value "Cross Region Restore"      "${vault_name}" "${resource_group}" "properties.crossRegionRestoreFlag"          "eq" "Enabled" "properties.crossRegionRestoreFlag"
    # 5.1.2 Ensure immutability for Backup vaults is Enabled
    command="az backup policy list --vault-name \"${vault_name}\" --resource-group \"${resource_group}\" --query \"[].name\" --output tsv"
    command_message "${command}"
    policy_names=$( eval "${command}" )
    for policy_name in ${policy_names}; do
      check_azure_backup_policy_value "Immutability Settings"           "${policy_name}" "${vault_name}" "${resource_group}" "immutabilitySettings"                         "ne" ""                      ""
      check_azure_backup_policy_value "Immutability State"              "${policy_name}" "${vault_name}" "${resource_group}" "immutabilitySettings.state"                   "eq" "${immutability_state}" "--immutability-state"
      check_azure_backup_policy_value "Immutability Retention Duration" "${policy_name}" "${vault_name}" "${resource_group}" "immutabilitySettings.retentionDurationInDays" "eq" "${retention_days}"     "--retention-days"
    done
  done
}
