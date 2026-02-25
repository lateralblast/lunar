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
  query_string="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  set_value="${9}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  print_function  "check_azure_basic_authentication_publishing_credential_value"
  verbose_message "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az resource show --name \"${resource_name}\" --resource-group \"${resource_group}\" --resource-type \"${resource_type}\" --parent \"sites/${app_name}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\"" "fix"
            ;;
          *)
            verbose_message  "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${correct_value}\"" "fix"
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\"" "fix"
            ;;
          *)
            verbose_message  "az resource update --name \"${resource_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${correct_value}\"" "fix"
            ;;
        esac
      fi
    else
      increment_secure   "Azure Basic Authentication Publishing Credential for ${resource_name} for app \"${app_name}\" with resource group \"${resource_group}\" and resource \"${resource_name}\" and resource type \"${resource_type}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    fi
  fi
}
