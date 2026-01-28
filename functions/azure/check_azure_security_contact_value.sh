#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_security_contact_value 
#
# Check Azure Security Contact Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_security_contact_value () {
  contact_name="${1}"
  parameter_name="${2}"
  function="${3}"
  correct_value="${4}"
  print_function  "check_azure_security_contact_value"
  verbose_message "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" ${function} \"${correct_value}\"" "check"
  actual_value=$( az security contact show --name "${contact_name}" --query "${parameter_name}" --output tsv 2>/dev/null )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is \"${correct_value}\""
    else
      increment_insecure "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is not \"${correct_value}\""
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is not \"${correct_value}\""
    else
      increment_insecure "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is \"${correct_value}\""
    fi
  fi
}
