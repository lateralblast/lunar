#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_entra_diagnostic_settings
#
# Check Azure Entra Diagnostic Settings
#
# Refer to Section(s) 6.1.1.8 Page(s) 218-9 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_entra_diagnostic_settings () {
  print_function "audit_azure_entra_diagnostic_settings"
  verbose_message "Azure Entra Diagnostic Settings" "check"
}
