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
  app_id="${2}"
  app_name="${3}"
  resource_group="${4}"
  resource_type="${5}"
  query_string="${6}"
  function="${7}"
  correct_value="${8}"
  set_name="${9}"
  set_value="${10}"
  print_function "check_azure_app_service_app_value"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  check_message  "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
  case "${resource_type}" in
    "auth|identity")
      command="az webapp ${resource_type} show --id \"${app_id}\" --query \"${query_string}\" --output tsv 2> /dev/null"
      ;;
    *)
      command="az webapp show --id \"${app_id}\" --query \"${query_string}\" --output tsv 2> /dev/null"
      ;;
  esac
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${actual_value}" = "" ]; then
    case "${query_string}" in
      *Version)
        inc_secure "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not set"
        return
        ;;
    esac
  fi  
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${actual_value}\" and not \"${function}\" to \"${correct_value}\""
      if [ "${query_string}" = "virtualNetworkSubnetId" ]; then
        fix_message "az webapp vnet-integration add --resource-group <resource-group-name> --name <app-name> --vnet <virtual-network-name> --subnet <subnet-name>"
      fi
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                fix_message "az resource update --resource-type \"${resource_type}\" --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
                ;;
              "auth")
                fix_message "az webapp ${resource_type} update --id \"${app_id}\" ${set_name} \"${set_value}\""
                ;;
              "identity")
                fix_message "az webapp ${resource_type} assign --id \"${app_id}\" ${set_name} \"${set_value}\""
                ;;
              *)
                fix_message "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
                ;;
            esac
            ;;
          *)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                fix_message "az resource update --resource-type \"${resource_type}\" --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
              "auth")
                fix_message "az webapp ${resource_type} update --id \"${app_id}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
              "identity")
                fix_message "az webapp ${resource_type} assign --id \"${app_id}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
              *)
                fix_message "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
            esac
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_insecure "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ "${query_string}" = "virtualNetworkSubnetId" ]; then
        fix_message "az webapp vnet-integration add --resource-group <resource-group-name> --name <app-name> --vnet <virtual-network-name> --subnet <subnet-name>"
      fi
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                fix_message "az resource update --resource-type \"${resource_type}\" --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
                ;;
              "auth")
                fix_message "az webapp ${resource_type} update --id \"${app_id}\" ${set_name} \"${set_value}\""
                ;;
              "identity")
                fix_message "az webapp ${resource_type} assign --id \"${app_id}\" ${set_name} \"${set_value}\""
                ;;
              *)
                fix_message "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
                ;;
            esac
            ;;
          *)
            case "${resource_type}" in
              "Microsoft.Web/sites")
                fix_message "az resource update --resource-type \"${resource_type}\" --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
              "auth")
                fix_message "az webapp ${resource_type} update --id \"${app_id}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
              "identity")
                fix_message "az webapp ${resource_type} assign --id \"${app_id}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
              *)
                fix_message "az webapp update --name \"${app_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"${set_value}\""
                ;;
            esac
            ;;
        esac
      fi
    else
      inc_secure "Azure App Service App ${description} for app \"${app_name}\" with resource group \"${resource_group}\" and parameter \"${query_string}\" is \"${function}\" to \"${set_value}\""
    fi
  fi
}
