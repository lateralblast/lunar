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
# Refer to Section(s) 9.2.1-3 Page(s) 485-95 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_blob_storage () {
  print_function  "audit_azure_blob_storage"
  verbose_message "Azure Blob Storage" "check"
  command="az storage account list --query \"[].name\" --output tsv"
  command_message "${command}"
  storage_accounts=$( eval "${command}" )
  for storage_account in ${storage_accounts}; do
    # 9.2.1 Ensure that soft delete for blobs on Azure Blob Storage storage accounts is Enabled
    check_azure_storage_blob_value "Soft delete"   "${storage_account}" "service-properties" "delete-policy" "enabled" "eq" "true" "--enable"
    check_azure_storage_blob_value "Days retained" "${storage_account}" "service-properties" "delete-policy" "days"    "eq" "7"    "--days-retained"
    # 9.2.3 Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
    check_azure_storage_container_value "Versioning" "${storage_account}" "" "service-properties" "isVersioningEnabled" "eq" "true" "--enable-versioning"
    # 9.2.2 Ensure that soft delete for containers on Azure Blob Storage storage accounts is Enabled
    command="az storage account show --name \"${storage_account}\" --query \"resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    if [ "${azure_auth_mode}" = "login" ]; then
      container_names=$( az storage container list --account-name "${storage_account}" --query "[].name" --output tsv --auth-mode "${azure_auth_mode}" )
    else
      container_names=$( az storage container list --account-name "${storage_account}" --query "[].name" --output tsv )
    fi
    for container_name in ${container_names}; do
      check_azure_storage_container_value "Soft delete"   "${storage_account}" "${resource_group}" "service-properties" "containerDeleteRetentionPolicy.enabled" "eq" "true" "--enable-container-delete-retention"
      check_azure_storage_container_value "Days retained" "${storage_account}" "${resource_group}" "service-properties" "containerDeleteRetentionPolicy.days"    "eq" "7"    "--container-delete-retention-days"
    done 
  done
}
