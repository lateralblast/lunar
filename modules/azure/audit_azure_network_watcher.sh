#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_network_watcher
#
# Check Azure Network Watcher
#
# 7.6 Ensure that Network Watcher is 'Enabled' for Azure Regions that are in use
#
# Refer to Section(s) 7.6 Page(s) 306-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_network_watcher () {
  print_function  "audit_azure_network_watcher"
  verbose_message "Azure Network Watcher" "check"
  command="az network watcher list --query '[].id' --output tsv 2> /dev/null"
  command_message "$command"
  watcher_ids=$(eval "$command")
  if [ -z "${watcher_ids}" ]; then
    verbose_message "No Network Watcher instances found" "info"
    return
  fi
  for watcher_id in $watcher_ids; do
    check_azure_network_watcher_value "${watcher_id}" "provisioningState" "Succeeded"
  done
}
