#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_intune_logs
#
# Check Azure Intune Logs
#
# 6.1.1.10 Ensure that a Microsoft Intune diagnostic setting exists to send Microsoft Intune activity logs to an appropriate destination
#
# Refer to Section(s) 6.1.1.10 Page(s) 223-5 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_intune_logs () {
  print_function "audit_azure_intune_logs"
  verbose_message "Azure Intune Logs" "check"
}
