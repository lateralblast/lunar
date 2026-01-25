#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_logging_and_monitoring
#
# Check Azure Logging and Monitoring
#
# Refer to Section(s) 6.1.1.1 Page(s) 194-7 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.
audit_azure_logging_and_monitoring () {
  print_function "audit_azure_logging_and_monitoring"
  verbose_message "Azure Logging and Monitoring" "check"
  # 6.1.1.1 Ensure that a 'Diagnostic Setting' exists for Subscription Activity Logs
  # 6.1.1.2 Ensure Diagnostic Setting captures appropriate categories
  # 6.1.1.3 Ensure the storage account containing the container with activity logs is encrypted with customer-managed key (CMK)
  audit_azure_subscription_diagnostic_settings
}