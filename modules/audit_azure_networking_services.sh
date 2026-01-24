#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_networking_services
#
# Check Azure Networking Services
#
# Refer to Section(s) 7.1-16 Page(s) 287-337 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_networking_services () {
  print_function  "audit_azure_networking_services"
  verbose_message "Azure Networking Services" "check"
}
