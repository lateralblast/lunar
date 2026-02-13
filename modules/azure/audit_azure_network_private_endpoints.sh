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
  print_function  "audit_azure_network_private_endpoints"
  verbose_message "Azure Network Private Endpoints" "check"
  command="az network private-endpoint list --query \"[].id\" --output tsv"
  command_message "${command}"
  private_endpoints=$( eval "${command}" )
  for private_endpoint in ${private_endpoints}; do
    command="az network private-endpoint show --id \"${private_endpoint}\" --query \"id\" --output tsv"
    command_message "${command}"
    resource_name=$( eval "${command}" )
    command="az network private-endpoint show --id \"${private_endpoint}\" --query \"name\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    # 2.2.2.1 Ensure Private Endpoints are used to access {service}
    command="az network private-endpoint list --resource-group ${resource_group} --query \"[?contains(resourceGroup, '${resource_group}') && contains(name, '${resource_name}')]\" --output tsv"
    command_message "${command}"
    private_endpoints=$( eval "${command}" )
    if [ -z "${private_endpoints}" ]; then
      increment_insecure "Private Endpoints are not used to access ${resource_name}"
    else
      increment_secure "Private Endpoints are used to access ${resource_name}"
    fi
  done
}
