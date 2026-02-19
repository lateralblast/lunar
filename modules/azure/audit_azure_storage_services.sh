#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_storage_services
#
# Check Azure Storage Services
#
# 9.1.1     Ensure soft delete for Azure File Shares is Enabled
# 9.1.2     Ensure 'SMB protocol version' is set to 'SMB 3.1.1' or higher for SMB file shares
# 9.1.3     Ensure 'SMB channel encryption' is set to 'AES-256-GCM' or higher for SMB file shares
# 9.2.1     Ensure that soft delete for blobs on Azure Blob Storage storage accounts is Enabled
# 9.2.2     Ensure that soft delete for containers on Azure Blob Storage storage accounts is Enabled
# 9.2.3     Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
# 9.3.1.1   Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
# 9.3.1.2   Ensure that Storage Account access keys are periodically regenerated
# 9.3.1.3   Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
# 9.3.2.1   Ensure Private Endpoints are used to access Storage Accounts
# 9.3.2.2   Ensure that 'Public Network Access' is 'Disabled' for storage accounts
# 9.3.2.3   Ensure default network access rule for storage accounts is set to deny
# 9.3.3.1   Ensure that 'Default to Microsoft Entra authorization in the Azure portal' is set to 'Enabled'
# 9.3.4     Ensure that 'Secure transfer required' is set to 'Enabled'
# 9.3.5     Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access
# 9.3.6     Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'
# 9.3.7     Ensure 'Cross Tenant Replication' is not enabled (Automated)
# 9.3.8     Ensure that 'Allow Blob Anonymous Access' is set to 'Disabled'
# 9.3.9     Ensure Azure Resource Manager Delete locks are applied to Azure Storage Accounts
# 9.3.10    Ensure Azure Resource Manager ReadOnly locks are considered for Azure Storage Accounts
# 9.3.11    Ensure Redundancy is set to 'geo-redundant storage (GRS)' on critical Azure Storage Accounts
#
# Refer to Section(s) 9 Page(s) 473-549 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# 2.1.1.1   Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
# 2.1.1.2   Ensure that shared access signature (SAS) tokens expire within an hour - TBD
# 2.1.1.3   Ensure stored access policies (SAP) are used when generating shared access signature (SAS) tokens - Needs verification
# 2.1.2.1.1 Ensure Critical Data is Encrypted with Microsoft Managed Keys - Needs verification
# 2.1.2.2.1 Ensure Critical Data is Encrypted with Customer Managed Keys - TBD
# 2.2.1.1   Ensure public network access is Disabled
# 4.1.1     Ensure 'Key encryption key' is set to a customer-managed key for Azure Managed Lustre file systems
# 5.1.1     Ensure soft delete on Backup vaults is Enabled
# 5.1.2     Ensure immutability for Backup vaults is Enabled
# 5.1.3     Ensure backup data in Backup vaults is encrypted using customer-managed keys (CMK)
# 5.1.4     Ensure 'Use infrastructure encryption for this vault' is enabled on Backup vaults
# 5.1.5     Ensure 'Cross Region Restore' is set to 'Enabled' on Backup vaults
# 5.1.6     Ensure 'Cross Subscription Restore' is set to 'Disabled' or 'Permanently Disabled' on Backup vaults
# 5.2.1     Ensure soft delete on Recovery Services vaults is Enabled
# 5.2.2     Ensure immutability for Recovery Services vaults is Enabled
# 5.2.3     Ensure backup data in Recovery Services vaults is encrypted using customer-managed keys (CMK)
# 5.2.4     Ensure 'Use infrastructure encryption for this vault' is enabled on Recovery Services vaults
# 5.2.5     Ensure public network access on Recovery Services vaults is Disabled
# 5.2.6     Ensure 'Cross Region Restore' is set to 'Enabled' on Recovery Services vaults
# 5.2.7     Ensure 'Cross Subscription Restore' is set to 'Disabled' or 'Permanently Disabled' on Recovery Services vaults
# 8.1       Ensure soft delete for Azure File Shares is Enabled
# 8.2       Ensure root squash for NFS file shares is configured
# 8.3       Ensure 'SMB protocol version' is set to 'SMB 3.1.1' or higher for SMB file shares
# 8.4       Ensure 'SMB channel encryption' is set to 'AES-256-GCM' or higher for SMB file shares
# 10.1      Ensure 'Encryption key source' is set to 'Customer Managed Key' for Azure NetApp Files accounts
# 11.1      Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
# 11.2      Ensure that shared access signature (SAS) tokens expire within an hour - TBD
# 11.3      Ensure that soft delete for blobs on Azure Blob Storage storage accounts is Enabled
# 11.4      Ensure stored access policies (SAP) are used when generating shared access signature (SAS) tokens - TBD
# 11.5      Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
# 11.6      Ensure locked immutability policies are used for containers storing business-critical blob data 
# 12.1      Ensure double encryption is used for Azure Data Box in high-security environments - TBD
# 15.1      Ensure 'Public network access' is set to 'Disabled' on Azure Elastic SAN
# 15.2      Ensure customer-managed keys (CMK) are used to encrypt data at rest on Azure Elastic SAN volume groups
# 16.1      Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only' - TBD
# 16.2      Ensure that shared access signature (SAS) tokens expire within an hour - TBD
# 16.3      Ensure stored access policies (SAP) are used when generating shared access signature (SAS) tokens - TBD
# 17.1.1    Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
# 17.1.2    Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
# 17.1.3    Ensure that Storage Account Access Keys are Periodically Regenerated
# 17.1.4    Ensure that shared access signature (SAS) tokens expire within an hour
# 17.1.5    Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
# 17.1.6    Ensure Storage for Critical Data are Encrypted with Customer Managed Keys (CMK)
# 17.2.1    Ensure Private Endpoints are used to access Storage Accounts
# 17.2.2    Ensure that 'Public Network Access' is 'Disabled' for storage accounts
# 17.2.3    Ensure default network access rule for storage accounts is set to deny
# 17.4      Ensure that 'Secure transfer required' is set to 'Enabled'
# 17.5      Ensure that ‘Enable Infrastructure Encryption’ for Each Storage Account in Azure Storage is Set to ‘enabled’
# 17.8      Ensure Storage Logging is Enabled for Queue Service for 'Read', 'Write', and 'Delete' requests
# 17.9      Ensure Storage Logging is Enabled for Blob Service for 'Read', 'Write', and 'Delete' requests
# 17.10     Ensure Storage Logging is Enabled for Table Service for 'Read', 'Write', and 'Delete' Requests
# 17.11     Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'
# 17.12     Ensure 'Cross Tenant Replication' is not enabled
# 17.13     Ensure that 'Allow Blob Anonymous Access' is set to 'Disabled'
# 17.14     Ensure Azure Resource Manager Delete locks are applied to Azure Storage Accounts
#
# Refer to Sections(s) 2 Page(s) 25- Microsoft Azure Storage Services Benchmark v1.0.0
#
# Refer to CIS Microsoft Azure Compute Services Benchmark
#.

audit_azure_storage_services () {
  print_function  "audit_azure_storage_services"
  verbose_message "Azure Storage Services" "check"
  audit_azure_databricks
  audit_azure_blob_storage
  audit_azure_file_shares
  audit_azure_storage_accounts
  audit_azure_recovery_services_vaults
  audit_azure_managed_lustre
  audit_azure_backup_vaults
  audit_azure_netapp_files
  audit_azure_databox
  audit_azure_elastic_san
  audit_azure_storage_logging
  audit_azure_storage_accounts_locks
}
