#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_storage_services
#
# Check Azure Storage Services
#
# 9.1.1   Ensure soft delete for Azure File Shares is Enabled
# 9.1.2   Ensure 'SMB protocol version' is set to 'SMB 3.1.1' or higher for SMB file shares
# 9.1.3   Ensure 'SMB channel encryption' is set to 'AES-256-GCM' or higher for SMB file shares
# 9.2.1   Ensure that soft delete for blobs on Azure Blob Storage storage accounts is Enabled
# 9.2.2   Ensure that soft delete for containers on Azure Blob Storage storage accounts is Enabled
# 9.2.3   Ensure 'Versioning' is set to 'Enabled' on Azure Blob Storage storage accounts
# 9.3.1.1 Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
# 9.3.1.2 Ensure that Storage Account access keys are periodically regenerated
# 9.3.1.3 Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
# 9.3.2.1 Ensure Private Endpoints are used to access Storage Accounts
# 9.3.2.2 Ensure that 'Public Network Access' is 'Disabled' for storage accounts
# 9.3.2.3 Ensure default network access rule for storage accounts is set to deny
# 9.3.3.1 Ensure that 'Default to Microsoft Entra authorization in the Azure portal' is set to 'Enabled'
# 9.3.4   Ensure that 'Secure transfer required' is set to 'Enabled'
# 9.3.5   Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access
# 9.3.6   Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'
# 9.3.7   Ensure 'Cross Tenant Replication' is not enabled (Automated)
# 9.3.8   Ensure that 'Allow Blob Anonymous Access' is set to 'Disabled'
# 9.3.9   Ensure Azure Resource Manager Delete locks are applied to Azure Storage Accounts
# 9.3.10  Ensure Azure Resource Manager ReadOnly locks are considered for Azure Storage Accounts
# 9.3.11  Ensure Redundancy is set to 'geo-redundant storage (GRS)' on critical Azure Storage Accounts
#
# Refer to Section(s) 9 Page(s) 473-549 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# 2.1.1.1   Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
# 2.1.1.2   Ensure that shared access signature (SAS) tokens expire within an hour - TBD
# 2.1.1.3   Ensure stored access policies (SAP) are used when generating shared access signature (SAS) tokens - Needs verification
# 2.1.2.1.1 Ensure Critical Data is Encrypted with Microsoft Managed Keys - Needs verification
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
}
