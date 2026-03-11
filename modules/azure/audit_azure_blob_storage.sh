#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_blob_storage
#
# Check Azure Blob Storage
#
# 9.2.1  Ensure that soft delete for blobs on Azure Blob Storage storage accounts is Enabled
# 9.2.2  Ensure that soft delete for containers on Azure Blob Storage storage accounts is Enabled
# 9.2.3  Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
#
# Refer to Section(s) 9.2.1-3 Page(s) 485-95 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# 2.1.2.1.1 Ensure Critical Data is Encrypted with Microsoft Managed Keys - Needs verification
# 11.3      Ensure that soft delete for blobs on Azure Blob Storage storage accounts is Enabled - TBD
# 11.4      Ensure stored access policies (SAP) are used when generating shared access signature (SAS) tokens - TBD
# 11.5      Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
# 11.6      Ensure locked immutability policies are used for containers storing business-critical blob data 
# 17.5      Ensure that ‘Enable Infrastructure Encryption’ for Each Storage Blob in Azure Storage is Set to ‘enabled’ 
# 17.7      Ensure Soft Delete is Enabled for Azure Containers and Blob Storage
#
# Refer to Section(s) 2 Page(s) 25- CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_blob_storage () {
  print_function "audit_azure_blob_storage"
  check_message  "Azure Blob Storage"
  immutability_state="Locked"
  retention_days="7"
  command="az storage account list --query \"[].name\" --output tsv"
  command_message    "${command}"
  s_accounts=$( eval "${command}" 2> /dev/null )
  if [ -z "${s_accounts}" ]; then
    info_message "No Storage Accounts found"
    return
  fi
  for s_account in ${s_accounts}; do
    # 9.2.1 Ensure that soft delete for blobs on Azure Blob Storage storage accounts is Enabled
    # 17.7  Ensure Soft Delete is Enabled for Azure Containers and Blob Storage
    check_azure_storage_blob_policy_value       "Soft delete"   "${s_account}"    "service-properties" "delete-policy"       "enabled" "eq"   "true"                 "--enable"
    check_azure_storage_blob_policy_value       "Days retained" "${s_account}"    "service-properties" "delete-policy"       "days"    "eq"   "${retention_days}"    "--days-retained"
    # 9.2.3 Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
    # 11.5  Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
    check_azure_storage_account_container_value "Versioning"    "${s_account}" "" "service-properties" "isVersioningEnabled" "eq"      "true" "--enable-versioning"
    # 9.2.2 Ensure that soft delete for containers on Azure Blob Storage storage accounts is Enabled
    command="az storage account show --name \"${s_account}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    if [ "${azure_auth_mode}" = "login" ]; then
      command="az storage container list --account-name \"${s_account}\" --query \"[].name\" --output tsv --auth-mode \"${azure_auth_mode}\""
      command_message "${command}"
      c_names=$( eval "${command}" )
    else
      command="az storage container list --account-name \"${s_account}\" --query \"[].name\" --output tsv"
      command_message "${command}"
      c_names=$( eval "${command}" )
    fi
    for c_name in ${c_names}; do
      check_azure_storage_account_container_value "Soft delete"                "${s_account}" "${res_group}" "service-properties" "containerDeleteRetentionPolicy.enabled" "eq" "true"                     "--enable-container-delete-retention"
      check_azure_storage_account_container_value "Days retained"              "${s_account}" "${res_group}" "service-properties" "containerDeleteRetentionPolicy.days"    "eq" "${retention_days}"        "--container-delete-retention-days"
      # 2.1.2.1.1 Ensure Critical Data is Encrypted with Microsoft Managed Keys - Needs verification
      check_azure_storage_account_container_value "Data is encrytped with MMK" "${s_account}" "${res_group}" "encryptionScope.defaultEncryptionScope"                      "eq" "\$account-encryption-key"
      # 11.6      Ensure locked immutability policies are used for containers storing business-critical blob data 
      check_azure_storage_account_container_value "Immutability policy state"  "${s_account}" "${res_group}" "immutability-policy" "immutabilitySettings.state"            "eq" "${immutability_state}"    "--immutability-policy-state"
      # 17.5      Ensure that ‘Enable Infrastructure Encryption’ for Each Storage Blob in Azure Storage is Set to ‘enabled’ 
      command="az storage blob list --container-name \"${c_name}\" --account-name \"${s_account}\" --query \"[].name\" --output tsv"
      command_message    "${command}"
      blob_names=$( eval "${command}" )
      for blob_name in ${blob_names}; do
        check_azure_storage_blob_value            "Infrastructure encryption"  "${s_account}" "${c_name}"    "${blob_name}"        "properties.serverEncrypted"            "eq" "Enabled"
      done 
    done 
  done
}
