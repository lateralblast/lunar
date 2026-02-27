#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_vm_value
#
# Check Azure VM value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_vm_value () {
  description="${1}"
  vm_name="${2}"
  resource_group="${3}"
  parameter_name="${4}"
  function="${5}"
  correct_value="${6}"
  print_function "check_azure_vnet_value"
  verbose_message "Azure VM \"${vm_name}\" in Resource Group \"${resource_group}\" has \"${parameter_name}\" ${function} to \"${correct_value}\"" "check"
  command="az vm show --name \"${vm_name}\" --resource-group \"${resource_group}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
  command_message "$command"
  actual_value=$( eval "$command" )
  if [ "${function}" = "ne" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Azure VM \"${vm_name}\" in Resource Group \"${resource_group}\" does not have \"${parameter_name}\" ${function} to \"${correct_value}\""
    else
      increment_secure "Azure VM \"${vm_name}\" in Resource Group \"${resource_group}\" has \"${parameter_name}\" ${function} to \"${correct_value}\""
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "Azure VM \"${vm_name}\" in Resource Group \"${resource_group}\" has \"${parameter_name}\" ${function} to \"${correct_value}\""
    else
      increment_insecure "Azure VM \"${vm_name}\" in Resource Group \"${resource_group}\" does not have \"${parameter_name}\" ${function} to \"${correct_value}\""
    fi
  fi
}
