#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_security_services
#
# Check Azure Security Services
#
# Refer to Section(s) 8.1-5 Page(s) 338-472 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_security_services () {
  print_function  "audit_azure_security_services"
  verbose_message "Azure Security Services" "check"
}
