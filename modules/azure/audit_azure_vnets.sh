#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_vnets
#
# Check Azure VNets
#
# 7.11 Ensure subnets are associated with network security groups
#
# Refer to Section(s) 7.11 Page(s) 319-21 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_vnets () {
  print_function "audit_azure_vnets"
  check_message  "Azure VNets"
  command="az network vnet list --query '[].resourceGroup' --output tsv 2> /dev/null"
  command_message    "${command}"
  res_groups=$( eval "${command}" )
  if [ -z "${res_groups}" ]; then
    info_message "No VNets found"
    return
  fi
  for res_group in $res_groups; do
    command="az network vnet list --resource-group \"${res_group}\" --query '[].name' --output tsv 2> /dev/null"
    command_message   "${command}"
    vnet_list=$( eval "${command}" )
    for vnet_name in $vnet_list; do
      command="az network vnet show --name \"${vnet_name}\" --resource-group \"${res_group}\" --query 'subnets[].name' --output tsv 2> /dev/null"
      command_message     "${command}"
      subnet_list=$( eval "${command}" )
      for subnet_name in $subnet_list; do
        check_azure_vnet_value "${vnet_name}" "${res_group}" "${subnet_name}" "networkSecurityGroup.id" "ne" ""
      done
    done
  done
}
