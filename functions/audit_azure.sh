#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# funct_audit_azure
#
# Audit Azure
#.

funct_audit_azure () {
  print_function "funct_audit_azure"
  audit_mode=$1
  check_environment
  check_azure
  audit_azure_all
  print_results
}

# audit_azure_all
#
# Audit Azure all
#
# Run various Azure audit tests
# 
# This requires the Azure CLI to be installed and configured
#.

audit_azure_all () {
  audit_azure_databricks
  audit_azure_storage_accounts
}
