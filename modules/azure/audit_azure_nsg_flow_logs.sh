#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_nsg_flow_logs
#
# Check Azure NSG Flow Logs
#
# 6.1.1.5 Ensure that Network Security Group Flow logs are captured and sent to Log Analytics
#
# Refer to Section(s) 6.1.1.5 Page(s) 211-2 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_nsg_flow_logs () {
  print_function  "audit_azure_nsg_flow_logs"
  verbose_message "Azure NSG Flow Logs" "check"
}
