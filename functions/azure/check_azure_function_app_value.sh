#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_function_app_value
#
# Check Azure Function App value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_function_app_value () {
  description="${1}"
  app_name="${2}"
  resource_group="${3}"
  sub_function="${4}"
  resource_type="${5}"
  resource_name="${6}"
  query_string="${7}"
  function="${8}"
  correct_value="${9}"
  set_name="${10}"
  set_value="${11}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  print_function  "check_azure_function_app_value"
  verbose_message "Azure Function App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  if [ "${sub_function}" = "auth" ]; then
    command="az webapp auth show --name \"${app_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  else
    command="az functionapp show --name \"${app_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  fi
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "Azure Function App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "Azure Function App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ "${query_string}" = "virtualNetworkSubnetId" ]; then
        verbose_message "az functionapp vnet-integration add --resource-group <resource-group-name> --name <app-name> --vnet <virtual-network-name> --subnet <subnet-name>" "fix" 
      fi
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                verbose_message  "az resource update --resource-group \"${resource_group}\" --name \"${resource_name}\" --namespace \"${namespace_name}\" --resource-type \"${resource_type}\" --parent \"sites/${app_name}\" ${set_name} \"${set_value}\"" "fix"
                ;;
              "auth")
                verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
                ;;
              "identity")
                verbose_message  "az functionapp identity assign --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
                ;;
              *)
                verbose_message  "az functionapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
                ;;
            esac
            ;;
          *)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                verbose_message  "az resource update --resource-group \"${resource_group}\" --name \"${resource_name}\" --namespace \"${namespace_name}\" --resource-type \"${resource_type}\" --parent \"sites/${app_name}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
              "auth")
                verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
              "identity")
                verbose_message  "az functionapp identity assign --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
              *)
                verbose_message  "az functionapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
            esac
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "Azure Function App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ "${query_string}" = "virtualNetworkSubnetId" ]; then
        verbose_message "az functionapp vnet-integration add --resource-group <resource-group-name> --name <app-name> --vnet <virtual-network-name> --subnet <subnet-name>" "fix" 
      fi
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                verbose_message  "az resource update --resource-group \"${resource_group}\" --name \"${resource_name}\" --namespace \"${namespace_name}\" --resource-type \"${resource_type}\" --parent \"sites/${app_name}\" ${set_name} \"${set_value}\"" "fix"
                ;;
              "auth")
                verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
                ;;
              "identity")
                verbose_message  "az functionapp identity assign --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
                ;;
              *)
                verbose_message  "az functionapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\"" "fix"
                ;;
            esac
            ;;
          *)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                verbose_message  "az resource update --resource-group \"${resource_group}\" --name \"${resource_name}\" --namespace \"${namespace_name}\" --resource-type \"${resource_type}\" --parent \"sites/${app_name}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
              "auth")
                verbose_message  "az webapp auth update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
              "identity")
                verbose_message  "az functionapp identity assign --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
              *)
                verbose_message  "az functionapp config set --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\"" "fix"
                ;;
            esac
            ;;
        esac
      fi
    else
      increment_secure   "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${set_value}\""
    fi
  fi
}
