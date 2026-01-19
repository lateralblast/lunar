#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_databricks
#
# Check Azure Databricks workspaces
#
# Refer to Section(s) 2.1.1 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_databricks () {
  print_function  "audit_azure_databricks"
  verbose_message "Azure Databricks" "check"
}