#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_vnet_value
#
# Check Azure VNet value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_vnet_value () {
  vnet_name="${1}"
  resource_group="${2}"
  subnet_name="${3}"
  parameter_name="${4}"
  function="${5}"
  correct_value="${6}"
  print_function "check_azure_vnet_value"
  verbose_message "Azure VNet \"${vnet_name}\" in Resource Group \"${resource_group}\" Subnet \"${subnet_name}\" has \"${parameter_name}\" ${function} to \"${correct_value}\"" "check"
  command="az network vnet subnet show --name \"${subnet_name}\" --resource-group \"${resource_group}\" --vnet-name \"${vnet_name}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
  command_message "$command"
  actual_value=$( eval "$command" )
  if [ "${function}" = "ne" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Azure VNet \"${vnet_name}\" in Resource Group \"${resource_group}\" Subnet \"${subnet_name}\" does not have \"${parameter_name}\" ${function} to \"${correct_value}\""
    else
      increment_secure "Azure VNet \"${vnet_name}\" in Resource Group \"${resource_group}\" Subnet \"${subnet_name}\" has \"${parameter_name}\" ${function} to \"${correct_value}\""
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "Azure VNet \"${vnet_name}\" in Resource Group \"${resource_group}\" Subnet \"${subnet_name}\" has \"${parameter_name}\" ${function} to \"${correct_value}\""
    else
      increment_insecure "Azure VNet \"${vnet_name}\" in Resource Group \"${resource_group}\" Subnet \"${subnet_name}\" does not have \"${parameter_name}\" ${function} to \"${correct_value}\""
    fi
  fi
}
