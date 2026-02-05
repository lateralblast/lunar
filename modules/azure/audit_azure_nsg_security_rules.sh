#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_nsg_security_rules
#
# Check Azure NSG Security Rules
#
# 7.1 Ensure that RDP access from the Internet is evaluated and restricted
# 7.2 Ensure that SSH access from the Internet is evaluated and restricted
# 
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_nsg_security_rules () {
  print_function "audit_azure_nsg_security_rules"
  verbose_message "Azure NSG Security Rules" "check"
  command="az network nsg list --query \"[].id\" --output tsv 2> /dev/null"
  command_message "${command}"
  resource_ids=$( eval "${command}" )
  for resource_id in ${resource_ids}; do
    command="az network nsg show --ids ${resource_id} --query \"name\" --output tsv 2> /dev/null"
    command_message "${command}"
    resource_name=$( eval "${command}" )
    command="az network nsg show --ids ${resource_id} --query \"resourceGroup\" --output tsv 2> /dev/null"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    command="az network nsg rule list --resource-group ${resource_group} --nsg-name ${resource_name} --query \"[].id\" --output tsv 2> /dev/null"
    command_message "${command}"
    rule_ids=$( eval "${command}" )
    for rule_id in ${rule_ids}; do
      for port_no in 3389 22; do
        service_name=$( get_service_name_from_port_no "${port_no}" )
        check_azure_nsg_security_rule_value "${service_name}" "${rule_id}" "Inbound" "access"                "ne" "Allow"
        check_azure_nsg_security_rule_value "${service_name}" "${rule_id}" "Inbound" "destinationPortRange"  "ne" "${port_no}"
        check_azure_nsg_security_rule_value "${service_name}" "${rule_id}" "Inbound" "destinationPortRanges" "ne" "${port_no}"
        check_azure_nsg_security_rule_value "${service_name}" "${rule_id}" "Inbound" "sourceAddressPrefix"   "ne" "0.0.0.0/0"
        check_azure_nsg_security_rule_value "${service_name}" "${rule_id}" "Inbound" "sourceAddressPrefixes" "ne" "0.0.0.0/0"
      done
    done  
  done
}
