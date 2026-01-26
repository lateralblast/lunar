#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_storage_services
#
# Check Azure Storage Services
#
# Refer to Section(s) 3 Page(s) 63-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to CIS Microsoft Azure Compute Services Benchmark
#.

audit_azure_storage_services () {
  print_function  "audit_azure_storage_services"
  verbose_message "Azure Storage Services" "check"
  audit_azure_databricks
  audit_azure_blob_storage
  audit_azure_file_shares
  audit_azure_storage_account
}
