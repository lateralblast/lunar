#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_http_logs
#
# Check Azure App Service HTTP Logs
#
# 6.1.1.6  Ensure that logging for Azure AppService 'HTTP logs' is enabled
#
# Refer to Section 6.1.1.6 Page(s) 213-4 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_http_logs () {
  print_function  "audit_azure_app_service_http_logs"
  verbose_message "Azure App Service HTTP Logs" "check"
}
