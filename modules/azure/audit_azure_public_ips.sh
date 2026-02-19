#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_public_ips
#
# Audit Azure Public IPs
#
# 7.7   Ensure that Public IP addresses are Evaluated on a Periodic Basis (Manual)
#
# Refer to Section(s) 7.7 Page(s) 309-10 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_public_ips () {
  print_function "audit_azure_public_ips"
  verbose_message "Azure Public IPs" "check"
  command="az network public-ip list --query '[].id' --output tsv"
  command_message "${command}"
  resource_ids=$( eval "$command" )
  if [ -z "${resource_ids}" ]; then
    verbose_message "No Public IPs found" "notice"
    return
  fi
  for resource_id in $resource_ids; do
    check_azure_public_ip_value "${resource_id}" "ipAddress" "eq" ""
  done
}
