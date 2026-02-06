#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_waf_ssl_policy
#
# Check Azure WAF SSL Policy
#
# 7.12 Ensure the SSL policy's 'Min protocol version' is set to 'TLSv1_2' or higher on Azure Application Gateway
#
# Refer to Section(s) 7.12 Page(s) 322-4 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_waf_ssl_policy () {
  print_function  "audit_azure_waf_ssl_policy"
  verbose_message "Azure WAF SSL Policy" "check"
  command="az network application-gateway list --query '[].resourceGroup' --output tsv 2> /dev/null"
  command_message "$command"
  resource_groups=$(eval "$command")
  for resource_group in $resource_groups; do
    command="az network application-gateway list --resource-group "${resource_group}" --query '[].name' --output tsv 2> /dev/null"
    command_message "$command"
    waf_list=$(eval "$command")
    for waf_name in $waf_list; do
      check_azure_waf_value "ssl-policy" "${waf_name}" "${resource_group}" "firewallPolicy.id" "ne" "" "" ""
    done
  done
}
