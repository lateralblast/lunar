#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_network_watcher_flow_logs
#
# Check Azure Network Watcher Flow Logs
#
# 7.8 Ensure that virtual network flow log retention days is set to greater than or equal to 90
#
# Refer to Section(s) 7.8 Page(s) 311-3 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_network_watcher_flow_logs () {
  print_function  "audit_azure_network_watcher_flow_logs"
  verbose_message "Azure Network Watcher Flow Logs" "check"
  command="az network watcher list --query '[].location' --output tsv 2> /dev/null"
  command_message "$command"
  locations=$(eval "$command")
  if [ -z "${locations}" ]; then
    verbose_message "No Network Watcher instances found" "info"
    return
  fi
  for location in $locations; do
    command="az network watcher list-flow-logs --location \"${location}\" --query '[].name' --output tsv 2> /dev/null"
    command_message "$command"
    flow_logs=$(eval "$command")
    if [ -z "${flow_logs}" ]; then
      verbose_message "No Flow Logs found" "info"
      return
    fi
    for flow_log in $flow_logs; do
      check_azure_network_watcher_flow_logs_value "${location}" "${flow_log}" "retentionPolicy.days" "90" "retention"
    done
  done
}
