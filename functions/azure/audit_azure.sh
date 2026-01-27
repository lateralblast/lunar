#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_all
#
# Audit Azure all
#
# Run various Azure audit tests
# 
# This requires the Azure CLI to be installed and configured
#.

audit_azure_all () {
  audit_azure_survey
  audit_azure_extensions
  audit_azure_storage_services
  audit_azure_compute_services
  audit_azure_database_services
  audit_azure_identity_services
  audit_azure_logging_and_monitoring
  audit_azure_networking_services
  audit_azure_security_services
}

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
