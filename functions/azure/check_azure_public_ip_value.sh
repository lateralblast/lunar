#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_public_ip_value
#
# Check Azure Public IP Value
#
# 7.7   Ensure that Public IP addresses are Evaluated on a Periodic Basis (Manual)
#
# Refer to Section(s) 7.7 Page(s) 309-10 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_public_ip_value () {
  resource_id="${1}"
  parameter_name="${2}"
  function="${3}"
  correct_value="${4}"
  print_function "check_azure_public_ip_value"
  verbose_message "Azure Public IP \"${parameter_name}\" is ${function} to \"${correct_value}\"" "check"
  short_id=$( basename "${resource_id}" )
  command="az network public-ip show --id \"${resource_id}\" --query '${parameter_name}' --output tsv"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${parameter_name}" = "ipAddress" ]; then
    if [ "${correct_value}" = "" ]; then
      if [ "${actual_value}" = "${correct_value}" ]; then
        increment_secure "No Azure Public IP found for \"${short_id}\""
      else
        increment_insecure "Azure Public IP found for \"${short_id}\": \"${actual_value}\""
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "Azure Public IP \"${parameter_name}\" is ${function} to \"${correct_value}\""
    else
      increment_insecure "Azure Public IP \"${parameter_name}\" is not ${function} to \"${correct_value}\""
    fi
  fi
}
