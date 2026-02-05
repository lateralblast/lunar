#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_nsg_security_rule_value
#
# Check Azure NSG Security Rule values
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_nsg_security_rule_value () {
  description="${1}"
  rule_id="${2}"
  direction="${3}"
  parameter_name="${4}"
  function="${5}"
  correct_value="${6}"
  
  short_id=$( basename "${rule_id}" )
  print_function "check_azure_nsg_security_rule_value"
  verbose_message "NSG Rule ID \"${short_id}\" is \"${direction}\"" "check"
  command="az network nsg rule show --id ${rule_id} --query \"direction\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${actual_value}" = "${direction}" ]; then
    verbose_message "${description} rule ID \"${short_id}\" parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\"" "check"
    if [ "${function}" = "ne" ]; then
      command="az network nsg rule show --id ${rule_id} --query \"${parameter_name}\" --output tsv 2> /dev/null"
      command_message "${command}"
      actual_value=$( eval "${command}" )
      if [ "${actual_value}" = "${correct_value}" ] || [ "${actual_value}" = "*" ] || [ "${actual_value}" = "" ]; then
        increment_insecure "${description} \"${short_id}\" parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\" or \"*\" or \"\""
      else
        increment_secure   "${description} \"${short_id}\" parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
      fi
    fi
  else
    verbose_message "NSG Rule ID \"${short_id}\" is not \"${direction}\"" "notice"
  fi
}
