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
# Redis
# 2.1 Ensure 'Microsoft Entra Authentication' is 'Enabled' - TBD
# 2.2 Ensure that 'Allow access only via SSL' is set to 'Yes' - TBD
#
# Refer to Section(s) 2- Page(s) 11- Microsoft Azure Database Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_database_services () {
  print_function  "audit_azure_database_services"
  verbose_message "Azure Database Services" "check"
  audit_azure_redis_cache
}
