#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_network_watcher_flow_log_value
#
# Check Azure Network Watcher Flow Log Value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_network_watcher_flow_log_value () {
  location="${1}"
  flow_log="${2}"
  parameter_name="${3}"
  correct_value="${4}"
  print_function "check_azure_network_watcher_flow_log_value"
  verbose_message "Azure Network Watcher Flow Log \"${flow_log}\" has \"${parameter_name}\" set to \"${correct_value}\"" "check"
  command="az network watcher flow-log show --location \"${location}\" --name \"${flow_log}\" --query \"${parameter_name}\" --output tsv 2> /dev/null"
  command_message "$command"
  actual_value=$(eval "$command")
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure "Azure Network Watcher Flow Log \"${flow_log}\" has \"${parameter_name}\" set to \"${correct_value}\""
  else
    increment_insecure "Azure Network Watcher Flow Log \"${flow_log}\" has \"${parameter_name}\" not set to \"${correct_value}\""
  fi
}
