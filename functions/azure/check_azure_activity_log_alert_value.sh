#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_activity_log_alert_value
#
# Check Azure Activity Log Alert values
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_activity_log_alert_value () {
  description="${1}"
  subscription_id="${2}"
  alert_check="${3}"
  query_string="[].{Name:name,Enabled:enabled,Condition:condition.allOf,Actions:actions}"
  print_function  "check_azure_activity_log_alert_value"
  verbose_message "Azure Activity Log Alert for ${description} for subscription \"${subscription_id}\" is \"${alert_check}\"" "check"
  command="az monitor activity-log alert list --subscription \"${subscription_id}\" --query \"${query_string}\" | grep \"${alert_check}\""
  command_message "${command}" "exec"
  alert_check=$( eval "${command}" )
  if [ -n "${alert_check}" ]; then
    increment_secure   "Activity Log Alert for ${description} is enabled"
  else
    increment_insecure "Activity Log Alert for ${description} is not enabled"
  fi
}
