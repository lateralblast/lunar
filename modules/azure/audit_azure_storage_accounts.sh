#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_storage_accounts
#
# Check Azure Storage Accounts
#
# 9.3.1.1  Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
# 9.3.1.2  Ensure that Storage Account access keys are periodically regenerated
# 9.3.1.3  Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
# 9.3.2.1  Ensure Private Endpoints are used to access Storage Accounts
# 9.3.2.2  Ensure that 'Public Network Access' is 'Disabled' for storage accounts
# 9.3.2.3  Ensure default network access rule for storage accounts is set to deny
# 9.3.3.1  Ensure that 'Default to Microsoft Entra authorization in the Azure portal' is set to 'Enabled'
# 9.3.4    Ensure that 'Secure transfer required' is set to 'Enabled'
# 9.3.5    Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access
# 9.3.6    Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'
# 9.3.7    Ensure 'Cross Tenant Replication' is not enabled (Automated)
# 9.3.8    Ensure that 'Allow Blob Anonymous Access' is set to 'Disabled'
# 9.3.9    Ensure Azure Resource Manager Delete locks are applied to Azure Storage Accounts
# 9.3.10   Ensure Azure Resource Manager ReadOnly locks are considered for Azure Storage Accounts
# 9.3.11   Ensure Redundancy is set to 'geo-redundant storage (GRS)' on critical Azure Storage Accounts
#
# Refer to Section(s) 9.3.1-9.3.11 Page(s) 497-549 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# 2.1.1.1  Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
# 2.1.1.3  Ensure stored access policies (SAP) are used when generating shared access signature (SAS) tokens - Needs verification
# 2.2.1.1  Ensure public network access is Disabled
# 2.2.1.2  Ensure Network Access Rules are set to Deny-by-default
# 11.1     Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only' - TBD
# 11.2     Ensure that shared access signature (SAS) tokens expire within an hour - TBD
# 17.1.1   Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
# 17.1.2   Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
# 17.1.3   Ensure that Storage Account Access Keys are Periodically Regenerated
# 17.1.4   Ensure that shared access signature (SAS) tokens expire within an hour - TBD
# 17.1.5   Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
# 17.1.6   Ensure Storage for Critical Data are Encrypted with Customer Managed Keys (CMK) - TBD
# 17.2.1   Ensure Private Endpoints are used to access Storage Accounts
# 17.2.2   Ensure that 'Public Network Access' is 'Disabled' for storage accounts
# 17.2.3   Ensure default network access rule for storage accounts is set to deny
# 17.4     Ensure that 'Secure transfer required' is set to 'Enabled'
# 17.5     Ensure that ‘Enable Infrastructure Encryption’ for Each Storage Account in Azure Storage is Set to ‘enabled’
# 17.6     Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access
#
# Refer to Section(s) 2 Page(s) 25- CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_storage_accounts () {
  print_function  "audit_azure_storage_accounts"
  verbose_message "Azure Storage Accounts" "check"
  key_rotation="90"  # days
  sas_expiration="1" # hours
  command="az storage account list --query \"[].name\" --output tsv"
  command_message "${command}"
  storage_accounts=$( eval "${command}" )
  for storage_account in ${storage_accounts}; do
    command="az storage account show --name \"${storage_account}\" --query \"id\" --output tsv"
    command_message "${command}"
    resource_id=$( eval "${command}" )
    command="az storage account show --name \"${storage_account}\" --query \"resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    # 9.3.1.2  Ensure that Storage Account access keys are periodically regenerated
    # 17.1.3   Ensure that Storage Account Access Keys are Periodically Regenerated
    check_azure_storage_account_keys_rotation                                                     "${storage_account}"  "${resource_id}"    "${key_rotation}"                                  
    # 9.3.1.1  Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
    # 17.1.1   Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
    check_azure_storage_account_value         "Enable key rotation reminders"                     "${storage_account}"  "${resource_group}" "keyPolicy.keyExpirationPeriodInDays" "eq" "${key_rotation}" "--key-expiration-period-in-days"
    # 9.3.1.3  Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
    # 17.1.5   Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
    check_azure_storage_account_value         "Allow storage account key access"                  "${storage_account}"  "${resource_group}" "allowSharedKeyAccess"                "eq" "false"           "--allow-shared-key-access"
    # 9.3.2.1  Ensure Private Endpoints are used to access Storage Accounts
    # 17.2.1   Ensure Private Endpoints are used to access Storage Accounts
    check_azure_storage_account_value         "Private Endpoints are used to access"              "${storage_account}"  ""                  "privateEndpointConnections[0].id"    "ne" ""                ""
    # 9.3.2.2  Ensure that 'Public Network Access' is 'Disabled' for storage accounts
    # 17.2.2   Ensure that 'Public Network Access' is 'Disabled' for storage accounts
    # 2.2.1.1  Ensure public network access is Disabled
    check_azure_storage_account_value         "Public Network Access"                             "${storage_account}"  "${resource_group}" "publicNetworkAccess"                         "eq" "Disabled"        "--public-network-access"
    # 9.3.2.3  Ensure default network access rule for storage accounts is set to deny
    # 17.2.3   Ensure default network access rule for storage accounts is set to deny
    check_azure_storage_account_value         "Default network access rule"                       "${storage_account}"  "${resource_group}" "networkRuleSet.defaultAction"                "eq" "Deny"            "--default-action"
    # 9.3.3.1  Ensure that 'Default to Microsoft Entra authorization in the Azure portal' is set to 'Enabled' 
    check_azure_storage_account_value         "Microsoft Entra authorization"                     "${storage_account}"  "${resource_group}" "defaultToOAuthAuthentication"                "eq" "true"            "defaultToOAuthAuthentication"
    # 9.3.4    Ensure that 'Secure transfer required' is set to 'Enabled'
    check_azure_storage_account_value         "Secure transfer required"                          "${storage_account}"  "${resource_group}" "enableHttpsTrafficOnly"                      "eq" "true"            "--https-only"
    # 9.3.5    Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access
    # 17.6     Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access
    check_azure_storage_account_value         "Azure services on the trusted services list"       "${storage_account}"  "${resource_group}" "networkRuleSet.bypass"                       "eq" "AzureServices"   "--bypass"
    # 9.3.6    Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'
    check_azure_storage_account_value         "Minimum TLS version"                               "${storage_account}"  "${resource_group}" "minimumTlsVersion"                           "eq" "TLS1_2"          "--minimum-tls-version"
    # 9.3.7    Ensure 'Cross Tenant Replication' is not enabled
    check_azure_storage_account_value         "Cross Tenant Replication"                          "${storage_account}"  "${resource_group}" "allowCrossTenantReplication"                 "eq" "false"           "--allow-cross-tenant-replication"
    # 9.3.8    Ensure 'Allow blob public access' is set to 'Disabled'
    check_azure_storage_account_value         "Allow Blob Public Access"                          "${storage_account}"  "${resource_group}" "allowBlobPublicAccess"                       "eq" "false"           "allowBlobPublicAccess"
    # 9.3.9    Ensure Azure Resource Manager Delete locks are applied to Azure Storage Accounts
    check_azure_resource_manager_lock         "Azure Resource Manager Delete locks are applied"   "${storage_account}"  "${resource_group}" "[].level"                                    "eq" "CanNotDelete"    "Microsoft.Storage/storageAccounts"
    # 9.3.10   Ensure Azure Resource Manager ReadOnly locks are applied to Azure Storage Accounts
    check_azure_resource_manager_lock         "Azure Resource Manager ReadOnly locks are applied" "${storage_account}"  "${resource_group}" "[].level"                                    "eq" "ReadOnly"        "Microsoft.Storage/storageAccounts"
    # 9.3.11   Ensure Redundancy is set to 'geo-redundant storage (GRS)' on critical Azure Storage Accounts
    check_azure_storage_account_value         "Redundancy is set to geo-redundant storage (GRS)"  "${storage_account}"  "${resource_group}" "sku.name"                                    "eq" "Standard_GRS"    "--sku"
    # 2.1.1.1  Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
    # 17.1.2   Ensure 'Allowed Protocols' for shared access signature (SAS) tokens is set to 'HTTPS Only'
    check_azure_storage_account_value         "Allow Shared Key Access"                           "${storage_account}"  "${resource_group}" "allowSharedKeyAccess"                        "eq" "false"           ""
    # 17.4     Ensure that 'Secure transfer required' is set to 'Enabled'
    check_azure_storage_account_value         "Allowed Protocols for SAS tokens is HTTPS Only"    "${storage_account}"  "${resource_group}" "enableHttpsTrafficOnly"                      "eq" "true"            ""
    # 2.1.1.3  Ensure stored access policies (SAP) are used when generating shared access signature (SAS) tokens - Need verification
    check_azure_storage_account_value         "SAP are used when generating SAS tokens"           "${storage_account}"  "${resource_group}" "sasPolicy"                                   "ne" ""                ""
    # 2.2.1.2  Ensure Network Access Rules are set to Deny-by-default
    check_azure_storage_account_value         "Network Access Rules are set to Deny-by-default"   "${storage_account}"  "${resource_group}" "networkRuleSet.defaultAction"                "eq" "Deny"            " --default-action"
    # 17.5     Ensure that ‘Enable Infrastructure Encryption’ for Each Storage Account in Azure Storage is Set to ‘enabled’
    check_azure_storage_account_value         "Enable Infrastructure Encryption"                  "${storage_account}"  "${resource_group}" "encryption.infrastructureEncryption.enabled" "eq" "true"            "infrastructureEncryptionEnabled"
  done
}
