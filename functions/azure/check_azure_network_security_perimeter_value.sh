#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_network_security_perimeter_value
#
# Check Azure Network Security Perimeter Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_network_security_perimeter_value () {
  nsp_name="${1}"
  group_name="${2}"
  policy_name="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  print_function "check_azure_network_security_perimeter_value"
  if [ "${policy_name}" = "association" ]; then
    verbose_message "Azure Network Security Perimeter \"${nsp_name}\" is associated with \"${correct_value}\"" "check"
    command="az network perimeter association list --perimeter-name \"${nsp_name}\" --resource-group \"${group_name}\" --query \"${query_string}\" --output tsv 2> /dev/null"
    command_message "$command"
    actual_value=$(eval "$command")
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "Azure Network Security Perimeter \"${nsp_name}\" is associated with \"${correct_value}\""
    else
      increment_insecure "Azure Network Security Perimeter \"${nsp_name}\" is not associated with \"${correct_value}\""
    fi
  fi
}