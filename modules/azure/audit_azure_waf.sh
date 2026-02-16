#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_waf
#
# Check Azure WAF
#
# 7.10 Ensure Azure Web Application Firewall (WAF) is enabled on Azure Application Gateway
# 7.13 Ensure 'HTTP2' is set to 'Enabled' on Azure Application Gateway
#
# Refer to Section(s) 7.10,13 Page(s) 319-21,325-7 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_waf () {
  print_function  "audit_azure_waf"
  verbose_message "Azure WAF" "check"
  command="az network application-gateway list --query '[].resourceGroup' --output tsv 2> /dev/null"
  command_message "$command"
  resource_groups=$(eval "$command")
  for resource_group in $resource_groups; do
    command="az network application-gateway list --resource-group \"${resource_group}\" --query '[].name' --output tsv 2> /dev/null"
    command_message "$command"
    waf_list=$(eval "$command")
    for waf_name in $waf_list; do
      check_azure_waf_value "" "${waf_name}" "${resource_group}" "firewallPolicy.id" "ne" ""     ""        ""
      check_azure_waf_value "" "${waf_name}" "${resource_group}" "enableHttp2"       "eq" "true" "--http2" "Enabled"
    done
  done
}
