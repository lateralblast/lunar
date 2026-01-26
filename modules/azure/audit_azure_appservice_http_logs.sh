#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_appservice_http_logs
#
# Check Azure AppService HTTP Logs
#
# Refer to Section(s) 6.1.1.6 Page(s) 213-4 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_appservice_http_logs () {
  print_function  "audit_azure_appservice_http_logs"
  verbose_message "Azure AppService HTTP Logs" "check"
}
