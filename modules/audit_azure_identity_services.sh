#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_identity_services
#
# Check Azure Identity Services
#
# Refer to Section(s) 5.1-28 Page(s) 70-190 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_identity_services () {
  print_function  "audit_azure_identity_services"
  verbose_message "Azure Identity Services" "check"
}
