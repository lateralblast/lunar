#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_network_watcher_value
#
# Check Azure Network Watcher value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_network_watcher_value () {
  watcher_id="${1}"
  parameter_name="${2}"
  correct_value="${3}"
  print_function "check_azure_network_watcher_value"
  short_id=$( basename "${watcher_id}" )
  check_message  "Azure Network Watcher ID \"${short_id}\" has \"${parameter_name}\" set to \"${correct_value}\""
  command="az network watcher list --query \"[?contains(id,'${watcher_id}')].${parameter_name}\" --output tsv 2> /dev/null"
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${actual_value}" = "${correct_value}" ]; then
    inc_secure   "${parameter_name} is set to ${correct_value} for ${short_id}"
  else
    inc_insecure "${parameter_name} is not set to ${correct_value} for ${short_id}"
  fi
}
