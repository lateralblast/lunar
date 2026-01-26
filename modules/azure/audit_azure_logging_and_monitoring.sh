#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_logging_and_monitoring
#
# Check Azure Logging and Monitoring
#
# Refer to Section(s) 6.1-2 Page(s) 191-286 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.
audit_azure_logging_and_monitoring () {
  print_function "audit_azure_logging_and_monitoring"
  verbose_message "Azure Logging and Monitoring" "check"
  # 6.1.1.1 Ensure that a 'Diagnostic Setting' exists for Subscription Activity Logs
  # 6.1.1.2 Ensure Diagnostic Setting captures appropriate categories
  # 6.1.1.3 Ensure the storage account containing the container with activity logs is encrypted with customer-managed key (CMK)
  # 6.1.1.4 Ensure that logging for Azure Key Vault is 'Enabled'
  # 6.1.1.5 Ensure that Network Security Group Flow logs are captured and sent to Log Analytics - TBD
  audit_azure_subscription_diagnostic_settings
  audit_azure_diagnostic_setting_categories
  audit_azure_activity_logs_cmk
  audit_azure_key_vault_logging
  audit_azure_nsg_flow_logs
}
