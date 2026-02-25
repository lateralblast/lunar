#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_app_service_app_value
#
# Check Azure App Service App value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_app_service_app_value () {
  description="${1}"
  app_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  set_name="${8}"
  set_value="${9}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  print_function  "check_azure_app_service_app_value"
  verbose_message "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az webapp show --name \"${app_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
            ;;
          *)
            verbose_message  "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
            ;;
          *)
            verbose_message  "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
            ;;
        esac
      fi
    else
      increment_secure   "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${set_value}\""
    fi
  fi
}
