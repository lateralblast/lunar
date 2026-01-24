#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_logging_and_monitoring
#
# Check Azure Logging and Monitoring Services
#
# Refer to Section(s) 6.1-2 Page(s) 191-286 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_logging_and_monitoring () {
  print_function  "audit_azure_logging_and_monitoring"
  verbose_message "Azure Logging and Monitoring" "check"
}
