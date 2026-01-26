#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_intune_logs
#
# Check Azure Intune Logs
#
# Refer to Section(s) 6.1.1.10 Page(s) 223-5 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_intune_logs () {
  print_function "audit_azure_intune_logs"
  verbose_message "Azure Intune Logs" "check"
}
