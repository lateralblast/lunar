#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_authentication_type
#
# Check Azure Authentication Type
#
# 7.9  Ensure 'Authentication type' is set to 'Azure Active Directory' only for Azure VPN Gateway point-to-site configuration
#
# Refer to Section 7.9 Page(s) 315-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_authentication_type () {
  print_function  "audit_azure_authentication_type"
  verbose_message "Azure Authentication Type" "check"
}
