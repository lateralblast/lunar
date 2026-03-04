#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_network_private_endpoints
#
# Check Azure Network Private Endpoints
#
# 2.2.2.1 Ensure Private Endpoints are used to access {service}
#
# Refer to Section(s) 2 Page(s) 25- CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_network_private_endpoints () {
  print_function "audit_azure_network_private_endpoints"
  check_message  "Azure Network Private Endpoints"
  command="az network private-endpoint list --query \"[].id\" --output tsv"
  command_message     "${command}"
  p_endpoints=$( eval "${command}" 2> /dev/null )
  if [ -z "${p_endpoints}" ]; then
    info_message "No Private Endpoints found"
    return
  fi
  for p_endpoint in ${p_endpoints}; do
    command="az network private-endpoint show --id \"${p_endpoint}\" --query \"id\" --output tsv"
    command_message     "${command}"
    res_name=$( eval    "${command}" )
    command="az network private-endpoint show --id \"${p_endpoint}\" --query \"name\" --output tsv"
    command_message     "${command}"
    res_group=$( eval   "${command}" )
    # 2.2.2.1 Ensure Private Endpoints are used to access {service}
    command="az network private-endpoint list --resource-group \"${res_group}\" --query \"[?contains(resourceGroup, '${res_group}') && contains(name, '${res_name}')]\" --output tsv"
    command_message     "${command}"
    p_end_test=$( eval  "${command}" )
    if [ -z "${p_end_test}" ]; then
      inc_insecure "Private Endpoints are not used to access ${res_name}"
    else
      inc_secure   "Private Endpoints are used to access ${res_name}"
    fi
  done
}
