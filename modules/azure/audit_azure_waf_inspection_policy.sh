#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_waf_inspection_policy
#
# Check Azure WAF Inspection Policy
#
# 7.14 Ensure request body inspection is enabled in Azure Web Application Firewall policy on Azure Application Gateway
#
# Refer to Section(s) 7.14 Page(s) 328-30 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_waf_inspection_policy () {
  print_function  "audit_azure_waf_inspection_policy"
  verbose_message "Azure WAF Inspection Policy" "check"
  command="az network application-gateway list --query '[].resourceGroup' --output tsv 2> /dev/null"
  command_message "$command"
  resource_groups=$(eval "$command")
  for resource_group in $resource_groups; do
    command="az network application-gateway list --resource-group "${resource_group}" --query '[].name' --output tsv 2> /dev/null"
    command_message "$command"
    waf_list=$(eval "$command")
    for waf_name in $waf_list; do
      command="az network application-gateway show --resource-group "${resource_group}" --name "${waf_name}" --query 'firewallPolicy.id' --output tsv 2> /dev/null"
      command_message "$command"
      waf_ids=$(eval "$command")
      for waf_id in $waf_ids; do
        check_azure_waf_value "waf-policy" "${waf_id}" "" "policySettings.requestBodyCheck" "eq" "true" "request-body-check" "true"
      done
    done
  done
}
