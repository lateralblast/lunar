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
  resource_type="${4}"
  query_string="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${9}"
  set_value="${10}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  print_function  "check_azure_app_service_app_value"
  verbose_message "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  if [ "${resource_type}" = "auth" ]; then
    command="az webapp auth show --name \"${app_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  else
    command="az webapp show --name \"${app_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  fi
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
            if [ "${resource_type}" = "auth" ]; then
              verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
            else
              verbose_message  "az webapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""  "fix"
            fi
            ;;
          *)
            if [ "${resource_type}" = "" ]; then
              if [ "${resource_type}" = "auth" ]; then
                verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
              else
                verbose_message  "az webapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""  "fix"
              fi
            else
              verbose_message  "az resource update --resource-type \"${resource_type}\" --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
            fi
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
            if [ "${resource_type}" = "auth" ]; then
              verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
            else
              verbose_message  "az webapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""  "fix"
            fi
            ;;
          *)
            if [ "${resource_type}" = "" ]; then
              if [ "${resource_type}" = "auth" ]; then
                verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
              else
                verbose_message  "az webapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""  "fix"
              fi
            else
              verbose_message  "az resource update --resource-type \"${resource_type}\" --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
            fi
            ;;
        esac
      fi
    else
      increment_secure   "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${set_value}\""
    fi
  fi
}
