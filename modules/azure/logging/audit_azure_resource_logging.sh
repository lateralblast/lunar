#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_resource_logging
#
# Check Azure Resource Logging
#
# 6.1.4 Ensure that Azure Monitor Resource Logging is Enabled for All Services that Support it
#
# Refer to Section(s) 6.1.4 Page(s) 275-80 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_resource_logging () {
  print_function "audit_azure_resource_logging"
  check_message  "Azure Resource Logging"
  command="az account show --query id --output tsv"
  command_message  "${command}"
  sub_ids="$( eval "${command}" )"
  for sub_id in $sub_ids; do
    command="az resource list --subscription \"${sub_id}\" --query \"[].id\" --output tsv"
    command_message  "${command}"
    res_ids="$( eval "${command}" )"
    for res_id in ${res_ids}; do
      check_azure_monitoring_diagnostics_value "${res_id}"
    done
  done
}
