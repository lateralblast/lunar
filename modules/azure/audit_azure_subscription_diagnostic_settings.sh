#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_subscription_diagnostic_settings
#
# Check Azure Subscription Diagnostic Settings
#
# 6.1.1.1  Ensure that Diagnostic Settings are enabled for all Azure Subscriptions
# Refer to Section(s) 6.1.1.1 Page(s) 194-8   CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_subscription_diagnostic_settings () {
  print_function "audit_azure_subscription_diagnostic_settings"
  verbose_message "Azure Subscription Diagnostic Settings Activity Logs" "check"
  command="az account list --query \"[].id\" --output tsv 2>/dev/null"
  command_message "${command}" "exec"
  subscription_ids=$( eval "${command}" )
  for subscription_id in ${subscription_ids}; do
    command="az monitor diagnostic-settings list --scope /subscriptions/${subscription_id} --query \"[].value\" --output tsv 2>/dev/null"
    command_message "${command}" "exec"
    diagnostic_settings=$( eval "${command}" )
    if [ -z "${diagnostic_settings}" ]; then
      increment_insecure "There are no diagnostic settings for subscription ${subscription_id}"
    else
      increment_secure   "There are diagnostic settings for subscription ${subscription_id}"
    fi
    command="az resource list --subscription ${subscription_id} --query \"[].id\" --output tsv"
    command_message "${command}" "exec"
    resource_ids=$( eval "${command}" )
    for resource_id in ${resource_ids}; do
      command="az monitor diagnostic-settings list --resource ${resource_id} --query \"[].value\" --output tsv 2>/dev/null"
      command_message "${command}" "exec"
      diagnostic_settings=$( eval "${command}" )
      if [ -z "${diagnostic_settings}" ]; then
        increment_insecure "There are no diagnostic settings for resource ${resource_id}"
      else
        increment_secure   "There are diagnostic settings for resource ${resource_id}"
      fi    
    done
  done
}
