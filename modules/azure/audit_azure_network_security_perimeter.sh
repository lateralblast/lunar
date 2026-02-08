#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_network_security_perimeter
#
# Check Azure Network Security Perimeter
#
# 7.16 Ensure Azure Network Security Perimeter is used to secure Azure platform-as-a-service resources
#
# Refer to Section(s) 7.16 Page(s) 334-7 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_network_security_perimeter () {
  print_function  "audit_azure_network_security_perimeter"
  verbose_message "Azure Network Security Perimeter" "check"
  command="az group list --query '[].name' --output tsv 2> /dev/null"
  command_message "$command"
  group_names=$(eval "$command")
  for group_name in $group_names; do
    command="az network perimeter list --resource-group "${group_name}" --query '[].name' --output tsv 2> /dev/null"
    command_message "$command"
    nsp_list=$(eval "$command")
    if [ -z "${nsp_list}" ]; then
      increment_insecure "No Azure Network Security Perimeter found for resource group "${group_name}""
    else
      for nsp_name in $nsp_list; do
        check_azure_network_security_perimeter_value "${nsp_name}" "${group_name}" "association" "[].resourceGroup" "eq" "${group_name}"
      done
    fi
  done
}
