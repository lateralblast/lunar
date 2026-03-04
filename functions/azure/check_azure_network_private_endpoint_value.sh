#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_network_private_endpoint_value
#
# Check Azure Network Private Endpoint value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_network_private_endpoint_value () {
  endpoint_id="${1}"
  query_string="${2}"
  function="${3}"
  correct_value="${4}"
  print_function "check_azure_network_private_endpoint_value"
  check_message  "Azure Network Private Endpoint \"${endpoint_id}\" is \"${function}\" to \"${correct_value}\""
  command="az network private-endpoint list --query \"${query_string}\" --output tsv"
  command_message      "${command}"
  actual_value=$( eval "${command}" 2> /dev/null )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "Azure Network Private Endpoint \"${endpoint_id}\" is \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "Azure Network Private Endpoint \"${endpoint_id}\" is not \"${function}\" to \"${correct_value}\""
      fix_message  "az network private-endpoint create --resource-group <resource-group-name> \ "
      fix_message  "--location <location> --name <private-endpoint-name> --vnet-name <virtual-network-name> \ "
      fix_message  "--subnet <subnet-name> --private-connection-resource-id <fully-qualified-app-id> \ "
      fix_message  "--connection-name <connection-name> --group-id sites"
    fi
  else
    if [ "${function}" = "ne" ]; then
      if [ "${actual_value}" != "${correct_value}" ]; then
        inc_secure   "Azure Network Private Endpoint \"${endpoint_id}\" is \"${function}\" to \"${correct_value}\""
      else
        inc_insecure "Azure Network Private Endpoint \"${endpoint_id}\" is not \"${function}\" to \"${correct_value}\""
        fix_message  "az network private-endpoint create --resource-group <resource-group-name> \ "
        fix_message  "--location <location> --name <private-endpoint-name> --vnet-name <virtual-network-name> \ "
        fix_message  "--subnet <subnet-name> --private-connection-resource-id <fully-qualified-app-id> \ "
        fix_message  "--connection-name <connection-name> --group-id sites"
      fi
    fi
  fi
}
