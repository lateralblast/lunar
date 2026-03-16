#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_security_contact_value 
#
# Check Azure Security Contact value
#
# Refer to https://learn.microsoft.com/en-us/cli/azure/security/contact?view=azure-cli-latest
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_security_contact_value () {
  contact_name="${1}"
  parameter_name="${2}"
  function="${3}"
  correct_value="${4}"
  print_function "check_azure_security_contact_value"
  check_message  "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
  command="az security contact show --name \"${contact_name}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
      fix_message  "az security contact update --name ${contact_name} --email <email-address> --notifications-by-role '{\"state\":\"On\",\"roles\":[\"Owner\"]}' --alert-notifications '{\"state\":\"On\",\"minimalSeverity\":\"Low\"}'"
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is not \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "Azure Security Contact \"${contact_name}\" Parameter \"${parameter_name}\" is \"${function}\" to \"${correct_value}\""
      fix_message  "az security contact update --name ${contact_name} --email <email-address> --notifications-by-role '{\"state\":\"On\",\"roles\":[\"Owner\"]}' --alert-notifications '{\"state\":\"On\",\"minimalSeverity\":\"Low\"}'"
    fi
  fi
}
