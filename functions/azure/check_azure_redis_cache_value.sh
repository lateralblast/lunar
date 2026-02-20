#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_redis_cache_value
#
# Check Azure Redis Cache value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_redis_cache_value () {
  description="${1}"
  redis_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  set_name="${7}"
  print_function  "check_azure_redis_cache_value"
  verbose_message "${description} for Redis Cache \"${redis_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az redis show --name \"${redis_name}\" --resource-group \"${resource_group}\" --query \"${query_string}\" --output tsv 2> /dev/null"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${description} for Redis Cache \"${redis_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for Redis Cache \"${redis_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az redis update --name \"${redis_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\""           "fix"
            ;;
          *)
            verbose_message  "az redis update --name \"${redis_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${correct_value}\"" "fix"
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "${description} for Redis Cache \"${redis_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az redis update --name \"${redis_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\""           "fix"
            ;;
          *)
            verbose_message  "az redis update --name \"${redis_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${correct_value}\"" "fix"
            ;;
        esac
      fi
    else
      increment_secure   "${description} for Redis Cache \"${redis_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
    fi
  fi
}
