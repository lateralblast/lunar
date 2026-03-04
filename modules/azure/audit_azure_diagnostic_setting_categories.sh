#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_diagnostic_setting_categories
#
# Check Azure Diagnostic Setting Categories
#
# 6.1.1.2  Ensure Diagnostic Setting captures appropriate categories
#
# Refer to Section(s) 6.1.1.2 Page(s) 199-202 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_diagnostic_setting_categories () {
  print_function "audit_azure_diagnostic_setting_categories"
  check_message  "Azure Diagnostic Setting Categories"
  command="az account list --query \"[].id\" --output tsv 2>/dev/null"
  command_message "${command}"
  sub_ids=$( eval "${command}" )
  for sub_id in ${sub_ids}; do
    for setting in Administrative Alert Policy Security; do
      command="az monitor diagnostic-settings subscription list --subscription ${sub_id} | grep \"${setting}\" | grep -i \"enabled\" | grep true"
      command_message  "${command}"
      settings=$( eval "${command}" )
      if [ -z "${settings}" ]; then
        inc_insecure "There is no diagnostic setting for ${setting} for subscription ${sub_id}"
      else
        inc_secure   "There is a diagnostic setting for ${setting} for subscription ${sub_id}"
      fi
    done
  done
}
