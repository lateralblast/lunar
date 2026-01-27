#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_graph_diagnostic_settings
#
# Check Azure Graph Diagnostic Settings
#
# 6.1.1.8 Ensure that a Microsoft Graph diagnostic setting exists to send Microsoft Graph activity logs to an appropriate destination
# Refer to Section(s) 6.1.1.8 Page(s) 218-9 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_graph_diagnostic_settings () {
  print_function "audit_azure_graph_diagnostic_settings"
  verbose_message "Azure Graph Diagnostic Settings" "check"
}
