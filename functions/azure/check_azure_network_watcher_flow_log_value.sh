#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_network_watcher_flow_log_value
#
# Check Azure Network Watcher Flow Log value
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
  check_message  "Azure Network Watcher Flow Log \"${flow_log}\" has \"${query_string}\" set to \"${correct_value}\""
  command="az network watcher flow-log show --location \"${location}\" --name \"${flow_log}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${actual_value}" = "${correct_value}" ]; then
    inc_secure   "Azure Network Watcher Flow Log \"${flow_log}\" has \"${query_string}\" set to \"${correct_value}\""
  else
    inc_insecure "Azure Network Watcher Flow Log \"${flow_log}\" has \"${query_string}\" not set to \"${correct_value}\""
    fix_message  "az network watcher flow-log update --location \"${location}\" --name \"${flow_log}\" --\"${parameter_name}\" \"${correct_value}\""
  fi
}
