#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_security_setting_value
#
# Check Azure security setting values
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_security_setting_value () {
  description="${1}"
  setting_name="${2}"
  parameter_name="${3}"
  correct_value="${4}"
  print_function "check_azure_security_setting_value"
  verbose_message "${description} \"${setting_name}\" parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az security setting show --name \"${setting_name}\" --query \"${parameter_name}\" --output tsv 2>/dev/null"
  actual_value=$( eval "${command}" )
  command_message "${command}" "exec"
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure   "${description} \"${setting_name}\" parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
  else
    increment_insecure "${description} \"${setting_name}\" parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
  fi
}
