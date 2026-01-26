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
  print_function  "audit_azure_logging_and_monitoring"
  verbose_message "Azure Logging and Monitoring" "check"
  # 6.1.1.1 Ensure that a 'Diagnostic Setting' exists for Subscription Activity Logs
  audit_azure_subscription_diagnostic_settings
  # 6.1.1.2 Ensure Diagnostic Setting captures appropriate categories
  audit_azure_diagnostic_setting_categories
  # 6.1.1.3 Ensure the storage account containing the container with activity logs is encrypted with customer-managed key (CMK)
  audit_azure_activity_logs_cmk
  # 6.1.1.4 Ensure that logging for Azure Key Vault is 'Enabled'
  audit_azure_key_vault_logging
  # 6.1.1.5 Ensure that Network Security Group Flow logs are captured and sent to Log Analytics - TBD
  audit_azure_nsg_flow_logs
  # 6.1.1.6 Ensure that logging for Azure AppService 'HTTP logs' is enabled - TBD
  audit_azure_appservice_http_logs
  # 6.1.1.7 Ensure that virtual network flow logs are captured and sent to Log Analytics
  audit_azure_virtual_network_flow_logs
  # 6.1.1.8 Ensure that a Microsoft Entra diagnostic setting exists to send Microsoft Graph activity logs to an appropriate destination
  audit_azure_graph_diagnostic_settings
  # 6.1.1.9 Ensure that a Microsoft Entra diagnostic setting exists to send Microsoft Entra activity logs to an appropriate destination
  audit_azure_entra_diagnostic_settings
  # 6.1.1.10 Ensure that Intune logs are captured and sent to Log Analytics
  audit_azure_intune_logs
  # 6.1.2.1 Ensure that Activity Log Alert exists for Create Policy Assignment
  # 6.1.2.2 Ensure that Activity Log Alert exists for Delete Policy Assignment
  # 6.1.2.3 Ensure that Activity Log Alert exists for Create or Update Network Security Group
  # 6.1.2.4 Ensure that Activity Log Alert exists for Delete Network Security Group
  audit_azure_activity_log_alerts
}
