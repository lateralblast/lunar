#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_database_services
#
# Check Azure Database Services
#
# Refer to Section(s) 4 Page(s) 69 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to CIS Microsoft Azure Database Services Benchmark
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_database_services () {
  print_function  "audit_azure_database_services"
  verbose_message "Azure Database Services" "check"
}
