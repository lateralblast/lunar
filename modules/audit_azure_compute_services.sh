#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_compute_services
#
# Check Azure Compute Services
#
# Refer to Section(s) 3 Page(s) 63-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
# Refer to CIS Microsoft Azure Compute Services Benchmark
#.

audit_azure_compute_services () {
  print_function  "audit_azure_compute_services"
  verbose_message "Azure Compute Services" "check"
}
