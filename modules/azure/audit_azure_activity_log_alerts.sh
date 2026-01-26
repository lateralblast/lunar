#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_activity_log_alerts
#
# Check Azure Activity Log Alerts
#
# Refer to Section(s) 6.1.2.1 Page(s) 227-30 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.2 Page(s) 231-34 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to Section(s) 6.1.2.3 Page(s) 235-38 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_activity_log_alerts () {
  print_function "audit_azure_activity_log_alerts"
  verbose_message "Azure Activity Log Alerts" "check"
  subscription_ids="$( az account show --query id --output tsv )"
  for subscription_id in $subscription_ids; do
    alert_check=$( az monitor activity-log alert list --subscription "${subscription_id}" --query "[].{Name:name,Enabled:enabled,Condition:condition.allOf,Actions:actions}" | grep "Microsoft.Authorization/policyAssignments/write" ) 
    if [ -z "${alert_check}" ]; then
      increment_secure "Activity Log Alert for Create Policy Assignment is enabled"
    else
      increment_insecure "Activity Log Alert for Create Policy Assignment is not enabled"
    fi
    alert_check=$( az monitor activity-log alert list --subscription "${subscription_id}" --query "[].{Name:name,Enabled:enabled,Condition:condition.allOf,Actions:actions}" | grep "Microsoft.Authorization/policyAssignments/delete" )
    if [ -z "${alert_check}" ]; then
      increment_secure "Activity Log Alert for Delete Policy Assignment is enabled"
    else
      increment_insecure "Activity Log Alert for Delete Policy Assignment is not enabled"
    fi
    alert_check=$( az monitor activity-log alert list --subscription "${subscription_id}" --query "[].{Name:name,Enabled:enabled,Condition:condition.allOf,Actions:actions}" | grep "Microsoft.Network/networkSecurityGroups/write" )
    if [ -z "${alert_check}" ]; then
      increment_secure "Activity Log Alert for Create or Update Network Security Group is enabled"
    else
      increment_insecure "Activity Log Alert for Create or Update Network Security Group is not enabled"
    fi
  done
}
