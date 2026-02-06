#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_entra_diagnostic_settings
#
# Check Azure Entra Diagnostic Settings
#
# 6.1.1.9  Ensure that a Microsoft Entra diagnostic setting exists to send Microsoft Entra activity logs to an appropriate destination
#
# Refer to Section(s) 6.1.1.9 Page(s) 220-2 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_entra_diagnostic_settings () {
  print_function "audit_azure_entra_diagnostic_settings"
  verbose_message "Azure Entra Diagnostic Settings" "check"
}
