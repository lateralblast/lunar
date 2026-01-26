#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_nsg_flow_logs
#
# Check Azure NSG Flow Logs
#
# Refer to Section(s) 6.1.1.5 Page(s) 211-2 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.
audit_azure_nsg_flow_logs () {
  print_function "audit_azure_nsg_flow_logs"
  verbose_message "Azure NSG Flow Logs" "check"
}
