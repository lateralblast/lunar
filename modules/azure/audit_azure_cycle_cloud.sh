#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_cycle_cloud
#
# Check Azure CycleCloud
#
# Refer to Section(s) 2- Page(s) 22- CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_cycle_cloud () {
  print_function  "audit_azure_cycle_cloud"
  verbose_message "Azure CycleCloud" "check"
}
