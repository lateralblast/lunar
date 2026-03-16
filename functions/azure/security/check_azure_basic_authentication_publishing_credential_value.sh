#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_basic_authentication_publishing_credential_value
#
# Check Azure Basic Authentication Publishing Credential value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_basic_authentication_publishing_credential_value () {
  app_name="${1}"
  resource_group="${2}"
  resource_name="${3}"
  resource_type="${4}"
  name_space="${5}"
  query_string="${6}"
  function="${7}"
  correct_value="${8}"
  set_name="${9}"
  set_value="${10}"
  print_function "check_azure_basic_authentication_publishing_credential_value"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  check_message "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
  command="az resource show --name \"${resource_name}\" --name-space \"${name_space}\" --resource-group \"${resource_group}\" --resource-type \"${resource_type}\" --parent \"sites/${app_name}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            fix_message "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
            ;;
          *)
            fix_message "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_insecure "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            fix_message "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
            ;;
          *)
            fix_message "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""
            ;;
        esac
      fi
    else
      inc_secure "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
