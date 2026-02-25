#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_app_service_plan_value
#
# Check Azure App Service Plan value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_app_service_plan_value () {
  print_function  "check_azure_app_service_plan_value"
  plan_name="${1}"
  resource_group="${2}"
  query_string="${3}"
  function="${4}"
  correct_value="${5}"
  set_name="${7}"
  set_value="${8}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  command="az appservice plan show --name \"${plan_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null" 
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure "Azure App Service Plan \"${plan_name}\" with resource group \"${resource_group}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Azure App Service Plan \"${plan_name}\" with resource group \"${resource_group}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az appservice plan update --name \"${plan_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
            ;;
          *)
            verbose_message  "az appservice plan update --name \"${plan_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" != "${correct_value}" ]; then
      increment_secure "Azure App Service Plan \"${plan_name}\" with resource group \"${resource_group}\" is not \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Azure App Service Plan \"${plan_name}\" with resource group \"${resource_group}\" is \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az appservice plan update --name \"${plan_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
            ;;
          *)
            verbose_message  "az appservice plan update --name \"${plan_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
            ;;
        esac
      fi
    fi
  fi
}
