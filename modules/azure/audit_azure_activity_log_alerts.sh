#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_activity_log_alerts
#
# Check Azure Activity Log Alerts
#
# 6.1.2.1  Ensure that Activity Log Alert for Create Policy Assignment is enabled
# 6.1.2.2  Ensure that Activity Log Alert for Delete Policy Assignment is enabled
# 6.1.2.3  Ensure that Activity Log Alert exists for Create or Update Network Security Group
# 6.1.2.4  Ensure that Activity Log Alert exists for Delete Network Security Group
# 6.1.2.5  Ensure that Activity Log Alert exists for Create or Update Security Solution
# 6.1.2.6  Ensure that Activity Log Alert exists for Delete Security Solution
# 6.1.2.7  Ensure that Activity Log Alert exists for Create or Update SQL Server Firewall Rule
# 6.1.2.8  Ensure that Activity Log Alert exists for Delete SQL Server Firewall Rule
# 6.1.2.9  Ensure that Activity Log Alert exists for Create or Update Public IP Address rule
# 6.1.2.10 Ensure that Activity Log Alert exists for Delete Public IP Address rule
# 6.1.2.11 Ensure that Activity Log Alert exists for Service Health
# Refer to Section(s) 6.1.2.1  Page(s) 227-30 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.2  Page(s) 231-34 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.3  Page(s) 235-38 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.4  Page(s) 239-42 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.5  Page(s) 243-46 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.6  Page(s) 247-50 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.7  Page(s) 251-54 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.8  Page(s) 255-58 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.9  Page(s) 259-62 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.10 Page(s) 263-66 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.11 Page(s) 267-70 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_activity_log_alerts () {
  print_function "audit_azure_activity_log_alerts"
  verbose_message "Azure Activity Log Alerts" "check"
  command="az account show --query id --output tsv"
  command_message "${command}"
  subscription_ids="$( eval "${command}" )"
  for subscription_id in $subscription_ids; do
    # 6.1.2.1 Ensure that Activity Log Alert for Create Policy Assignment is enabled
    check_azure_activity_log_alert_value "Create Policy Assignment" "${subscription_id}" "Microsoft.Authorization/policyAssignments/write"
    # 6.1.2.2 Ensure that Activity Log Alert for Delete Policy Assignment is enabled
    check_azure_activity_log_alert_value "Delete Policy Assignment" "${subscription_id}" "Microsoft.Authorization/policyAssignments/delete"
    # 6.1.2.3 Ensure that Activity Log Alert exists for Create or Update Network Security Group
    check_azure_activity_log_alert_value "Create or Update Network Security Group" "${subscription_id}" "Microsoft.Network/networkSecurityGroups/write"
    # 6.1.2.4 Ensure that Activity Log Alert exists for Delete Network Security Group
    check_azure_activity_log_alert_value "Delete Network Security Group" "${subscription_id}" "Microsoft.Network/networkSecurityGroups/delete"
    # 6.1.2.5 Ensure that Activity Log Alert exists for Create or Update Security Solution
    check_azure_activity_log_alert_value "Create or Update Security Solution" "${subscription_id}" "Microsoft.Security/securitySolutions/write"
    # 6.1.2.6 Ensure that Activity Log Alert exists for Delete Security Solution
    check_azure_activity_log_alert_value "Delete Security Solution" "${subscription_id}" "Microsoft.Security/securitySolutions/delete"
    # 6.1.2.7 Ensure that Activity Log Alert exists for Create or Update SQL Server Firewall Rule
    check_azure_activity_log_alert_value "Create or Update SQL Server Firewall Rule" "${subscription_id}" "Microsoft.Sql/servers/firewallRules/write"
    # 6.1.2.8 Ensure that Activity Log Alert exists for Delete SQL Server Firewall Rule
    check_azure_activity_log_alert_value "Delete SQL Server Firewall Rule" "${subscription_id}" "Microsoft.Sql/servers/firewallRules/delete"
    # 6.1.2.9 Ensure that Activity Log Alert exists for Create or Update Public IP Address rule
    check_azure_activity_log_alert_value "Create or Update Public IP Address rule" "${subscription_id}" "Microsoft.Network/publicIPAddresses/write"
    # 6.1.2.10 Ensure that Activity Log Alert exists for Delete Public IP Address rule
    check_azure_activity_log_alert_value "Delete Public IP Address rule" "${subscription_id}" "Microsoft.Network/publicIPAddresses/delete"
    # 6.1.2.11 Ensure that Activity Log Alert exists for Service Health
    check_azure_activity_log_alert_value "Service Health" "${subscription_id}" "ServiceHealth"
  done
}
