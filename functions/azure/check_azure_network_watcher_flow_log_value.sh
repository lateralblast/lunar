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
  query_string="${3}"
  correct_value="${4}"
  parameter_name="${5}"
  print_function "check_azure_network_watcher_flow_log_value"
  verbose_message "Azure Network Watcher Flow Log \"${flow_log}\" has \"${query_string}\" set to \"${correct_value}\"" "check"
  command="az network watcher flow-log show --location \"${location}\" --name \"${flow_log}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "$command"
  actual_value=$(eval "$command")
  if [ "${actual_value}" = "${correct_value}" ]; then
    increment_secure "Azure Network Watcher Flow Log \"${flow_log}\" has \"${query_string}\" set to \"${correct_value}\""
  else
    increment_insecure "Azure Network Watcher Flow Log \"${flow_log}\" has \"${query_string}\" not set to \"${correct_value}\""
    verbose_message    "az network watcher flow-log update --location \"${location}\" --name \"${flow_log}\" --\"${parameter_name}\" \"${correct_value}\""
  fi
}
