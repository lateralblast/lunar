#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_storage_account_locks
#
# Audit Azure Storage Account Locks
#
# 17.14 Ensure Azure Resource Manager Delete locks are applied to Azure Storage Accounts
#
# Refer to Section(s) 17.14 Page(s) 224- CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#

audit_azure_storage_account_locks () {
  print_function  "audit_azure_storage_account_locks"
  verbose_message "Azure Storage Account Locks" "check"
  resource_type="Microsoft.Storage/storageAccounts"
  audit_azure_locks "${resource_type}"
}