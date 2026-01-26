#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_diagnostic_setting_categories
#
# Check Azure Diagnostic Setting Categories
#
# Refer to Section(s) 6.1.1.2 Page(s) 199-202 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_diagnostic_setting_categories () {
  print_function  "audit_azure_diagnostic_setting_categories"
  verbose_message "Azure Diagnostic Setting Categories" "check"
  subscription_ids=$( az account list --query "[].id" -o tsv 2>/dev/null )
  for subscription_id in ${subscription_ids}; do
    for setting in Administrative Alert Policy Security; do
      diagnostic_setting=$( az monitor diagnostic-settings subscription list --subscription ${subscription_id} | grep "${setting}" | grep -i "enabled" | grep true )
      if [ -z "${diagnostic_setting}" ]; then
        increment_insecure "There is no diagnostic setting for ${setting} for subscription ${subscription_id}"
      else
        increment_secure   "There is a diagnostic setting for ${setting} for subscription ${subscription_id}"
      fi
    done
  done
}
