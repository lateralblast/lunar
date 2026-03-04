#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_subscription_diagnostic_settings
#
# Check Azure Subscription Diagnostic Settings
#
# 6.1.1.1  Ensure that Diagnostic Settings are enabled for all Azure Subscriptions
#
# Refer to Section(s) 6.1.1.1 Page(s) 194-8   CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_subscription_diagnostic_settings () {
  print_function "audit_azure_subscription_diagnostic_settings"
  check_message  "Azure Subscription Diagnostic Settings Activity Logs"
  command="az account list --query \"[].id\" --output tsv 2>/dev/null"
  command_message "${command}"
  sub_ids=$( eval "${command}" )
  for sub_id in ${sub_ids}; do
    command="az monitor diagnostic-settings list --scope /subscriptions/${sub_id} --query \"[].value\" --output tsv 2>/dev/null"
    command_message  "${command}"
    settings=$( eval "${command}" )
    if [ -z "${settings}" ]; then
      inc_insecure "There are no diagnostic settings for subscription ${sub_id}"
    else
      inc_secure   "There are diagnostic settings for subscription ${sub_id}"
    fi
    command="az resource list --subscription ${sub_id} --query \"[].id\" --output tsv"
    command_message     "${command}"
    res_ids=$( eval "${command}" )
    for res_id in ${res_ids}; do
      command="az monitor diagnostic-settings list --resource ${res_id} --query \"[].value\" --output tsv 2>/dev/null"
      command_message  "${command}"
      settings=$( eval "${command}" )
      if [ -z "${settings}" ]; then
        inc_insecure "There are no diagnostic settings for resource ${res_id}"
      else
        inc_secure   "There are diagnostic settings for resource ${res_id}"
      fi    
    done
  done
}
