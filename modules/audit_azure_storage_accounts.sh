

audit_azure_storage_accounts () {
  print_function  "audit_azure_storage_accounts"
  verbose_message "Azure Storage Accounts" "check"
  storage_accounts=$( az storage account list --query "[].name" -o tsv )
  for storage_account in ${storage_accounts}; do
    resource_id=$( az storage account show --name "${storage_account}" --query "id" -o tsv )
    resource_group=$( az storage account show --name "${storage_account}" --query "resourceGroup" -o tsv )
    # 9.3.1.2 Ensure that Storage Account access keys are periodically regenerated
    check_azure_storage_account_keys_rotation                                               "${storage_account}"  "${resource_id}"    "90"
    # 9.3.1.1 Ensure that 'Enable key rotation reminders' is enabled for each Storage Account
    check_azure_storage_account_value  "Enable key rotation reminders"                      "${storage_account}"  "${resource_group}" "keyPolicy.keyExpirationPeriodInDays"  "eq" "90"            "--key-expiration-period-in-days"
    # 9.3.1.3 Ensure 'Allow storage account key access' for Azure Storage Accounts is 'Disabled'
    check_azure_storage_account_value  "Allow storage account key access"                   "${storage_account}"  "${resource_group}" "allowSharedKeyAccess"                 "eq" "false"         "--allow-shared-key-access"
    # 9.3.2.1 Ensure Private Endpoints are used to access Storage Accounts
    check_azure_storage_account_value  "Private Endpoints are used to access"               "${storage_account}"  ""                  "privateEndpointConnections[0].id"     "ne" ""              ""
    # 9.3.2.2 Ensure that 'Public Network Access' is 'Disabled' for storage accounts
    check_azure_storage_account_value  "Public Network Access is"                           "${storage_account}"  "${resource_group}" "publicNetworkAccess"                  "eq" "Disabled"      "--public-network-access"
    # 9.3.2.3 Ensure default network access rule for storage accounts is set to deny
    check_azure_storage_account_value  "Default network access rule"                        "${storage_account}"  "${resource_group}" "networkRuleSet.defaultAction"         "eq" "Deny"          "--default-action"
    # 9.3.3.1 Ensure that 'Default to Microsoft Entra authorization in the Azure portal' is set to 'Enabled' 
    check_azure_storage_account_value  "Microsoft Entra authorization"                      "${storage_account}"  "${resource_group}" "defaultToOAuthAuthentication"         "eq" "true"          "defaultToOAuthAuthentication"
    # 9.3.4   Ensure that 'Secure transfer required' is set to 'Enabled'
    check_azure_storage_account_value  "Secure transfer required"                           "${storage_account}"  "${resource_group}" "enableHttpsTrafficOnly"               "eq" "true"          "--https-only"
    # 9.3.5   Ensure 'Allow Azure services on the trusted services list to access this storage account' is Enabled for Storage Account Access
    check_azure_storage_account_value  "Azure services on the trusted services list"        "${storage_account}"  "${resource_group}" "networkRuleSet.bypass"                "eq" "AzureServices" "--bypass"
    # 9.3.6   Ensure the 'Minimum TLS version' for storage accounts is set to 'Version 1.2'
    check_azure_storage_account_value  "Minimum TLS version"                                "${storage_account}"  "${resource_group}" "minimumTlsVersion"                    "eq" "TLS1_2"        "--minimum-tls-version"
    # 9.3.7   Ensure 'Cross Tenant Replication' is not enabled
    check_azure_storage_account_value  "Cross Tenant Replication"                           "${storage_account}"  "${resource_group}" "allowCrossTenantReplication"          "eq" "false"         "--allow-cross-tenant-replication"
    # 9.3.8   Ensure 'Allow blob public access' is set to 'Disabled'
    check_azure_storage_account_value  "Allow Blob Public Access"                           "${storage_account}"  "${resource_group}" "allowBlobPublicAccess"                "eq" "false"         "allowBlobPublicAccess"
    # 9.3.9   Ensure Azure Resource Manager Delete locks are applied to Azure Storage Accounts
    check_azure_resource_manager_lock  "Azure Resource Manager Delete locks are applied"    "${storage_account}"  "${resource_group}" "[].level"                             "eq" "CanNotDelete"  "Microsoft.Storage/storageAccounts"
    # 9.3.10  Ensure Azure Resource Manager ReadOnly locks are applied to Azure Storage Accounts
    check_azure_resource_manager_lock  "Azure Resource Manager ReadOnly locks are applied"  "${storage_account}"  "${resource_group}" "[].level"                             "eq" "ReadOnly"      "Microsoft.Storage/storageAccounts"
    # 9.3.11  Ensure Redundancy is set to 'geo-redundant storage (GRS)' on critical Azure Storage Accounts
    check_azure_storage_account_value  "Redundancy is set to geo-redundant storage (GRS)"   "${storage_account}"  "${resource_group}" "sku.name"                             "eq" "Standard_GRS"  "--sku"
  done
}
