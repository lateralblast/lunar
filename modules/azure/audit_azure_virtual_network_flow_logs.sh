#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_virtual_network_flow_logs
#
# Check Azure Virtual Network Flow Logs
#
# Refer to Section(s) 6.1.1.7 Page(s) 215-7 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_virtual_network_flow_logs () {
  print_function "audit_azure_virtual_network_flow_logs"
  verbose_message "Azure Virtual Network Flow Logs" "check"
}
