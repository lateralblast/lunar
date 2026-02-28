#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_file_shares
#
# Check Azure File Shares
#
# 9.1.1 Ensure soft delete for Azure File Shares is Enabled
# 9.1.2 Ensure 'SMB protocol version' is set to 'SMB 3.1.1' or higher for SMB file shares
# 9.1.3 Ensure 'SMB channel encryption' is set to 'AES-256-GCM' or higher for SMB file shares
#
# Refer to Section(s) 9.1.1-3 Page(s) 475-84 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# 8.2 Ensure root squash for NFS file shares is configured 
# 8.3 Ensure 'SMB protocol version' is set to 'SMB 3.1.1' or higher for SMB file shares
# 8.4 Ensure 'SMB channel encryption' is set to 'AES-256-GCM' or higher for SMB file shares
#
# Refer to Sections(s) 8 Page(s) 106-19 Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_file_shares () {
  print_function  "audit_azure_file_shares"
  verbose_message "Azure File Shares" "check"
  command="az storage account list --query \"[].name\" --output tsv"
  command_message "${command}"
  storage_accounts=$( eval "${command}" 2> /dev/null )
  if [ -z "${storage_accounts}" ]; then
    verbose_message "No Storage Accounts found" "info"
    return
  fi
  for storage_account in ${storage_accounts}; do
    command="az storage account show --name \"${storage_account}\" --query \"resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    # 9.1.1 Ensure soft delete for Azure File Shares is Enabled
    check_azure_file_share_value "Days retained"             "${storage_account}" "${resource_group}" "service-properties" "shareDeleteRetentionPolicy.days"        "eq" "7"           "--share-delete-retention-days"   ""
    check_azure_file_share_value "Soft Delete"               "${storage_account}" "${resource_group}" "service-properties" "shareDeleteRetentionPolicy.enabled"     "eq" "true"        "--enable-share-delete-retention" ""
    command="az storage account file-service-properties show --name \"${storage_account}\" --resource-group \"${resource_group}\" |grep -i smb"
    command_message "${command}"
    protocol_check=$( eval "${command}" )
    if [ -n "${protocol_check}" ]; then
      # 9.1.2 Ensure 'SMB protocol version' is set to 'SMB 3.1.1' or higher for SMB file shares
      # 8.3 Ensure 'SMB protocol version' is set to 'SMB 3.1.1' or higher for SMB file shares
      check_azure_file_share_value "SMB Protocol Version"    "${storage_account}" "${resource_group}" "service-properties" "protocolSettings.smb.versions"          "eq" "SMB3.1.1"    "--versions"
      # 9.1.3 Ensure 'SMB channel encryption' is set to 'AES-256-GCM' or higher for SMB file shares
      # 8.4   Ensure 'SMB channel encryption' is set to 'AES-256-GCM' or higher for SMB file shares
      check_azure_file_share_value "SMB Channel Encryption"  "${storage_account}" "${resource_group}" "service-properties" "protocolSettings.smb.channelEncryption" "eq" "AES-256-GCM" "--channel-encryption"
    fi
    command="az storage account file-service-properties show --name \"${storage_account}\" --resource-group \"${resource_group}\" |grep -i nfs"
    command_message "${command}"
    protocol_check=$( eval "${command}" )
    if [ -n "${protocol_check}" ]; then
      # 8.2 Ensure root squash for NFS file shares is configured 
      check_azure_file_share_value "NFS Root Squash"         "${storage_account}" "${resource_group}" "service-properties" "protocolSettings.nfs.rootSquash"        "eq"  "RootSquash"    "rootSquash"
    fi
  done
}
