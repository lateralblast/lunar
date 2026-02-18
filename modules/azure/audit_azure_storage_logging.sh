#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_storage_logging
#
# Check Azure Storage Logging
#
# 17.8 Ensure Storage Logging is Enabled for Queue Service for 'Read', 'Write', and 'Delete' requests
# 17.9 Ensure Storage Logging is Enabled for Blob Service for 'Read', 'Write', and 'Delete' requests
#
# Refer to Section(s) 17.8 Page(s) 205-7 Microsoft Azure Storage Services Benchmark v1.0.0
#
# Refer to CIS Microsoft Azure Compute Services Benchmark
#.

audit_azure_storage_logging () {
  print_function  "audit_azure_storage_logging"
  verbose_message "Azure Storage Logging" "check"
  retention_days="90"
  log_value="rwd"
  command="az storage account list --query \"[].name\" --output tsv"
  command_message "${command}"
  storage_accounts=$( eval "${command}" )
  for storage_account in ${storage_accounts}; do
    # 17.8 Ensure Storage Logging is Enabled for Queue Service for 'Read', 'Write', and 'Delete' requests
    # 17.9 Ensure Storage Logging is Enabled for Blob Service for 'Read', 'Write', and 'Delete' requests
    for service_type in queue blob; do
      for request_type in read write delete; do
        check_azure_storage_logging_value "Storage Logging" "${storage_account}" "${service_type}" "[].${service_type}.${request_type}" "eq" "true" ""
      done
      check_azure_storage_logging_value "Storage Logging" "${storage_account}" "${service_type}" "[].${service_type}.retentionPolicy.days" "eq" "${retention_days}" "${log_value}"
  done
}
