#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_mysql_db_value
#
# Check Azure MySQL DB value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_mysql_db_value () {
  description="${1}"
  server_type="${2}"
  mysql_name="${3}"
  resource_group="${4}"
  query_string="${5}"
  function="${6}"
  correct_value="${7}"
  set_name="${8}"
  set_value="${9}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  print_function  "check_azure_mysql_db_value"
  verbose_message "${description} for MySQL ${server_type} DB \"${mysql_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az mysql ${server_type} show --name \"${mysql_name}\" --resource-group \"${resource_group}\" --query \"[].${query_string}\" --output tsv"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${description} for MySQL ${server_type} DB \"${mysql_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for MySQL ${server_type} DB \"${mysql_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az mysql ${server_type} update --name \"${mysql_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""           "fix"
            ;;
          *)
            verbose_message  "az mysql ${server_type} update --name \"${mysql_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${set_value}\"" "fix"
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "${description} for MySQL ${server_type} DB \"${mysql_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az mysql ${server_type} update --name \"${mysql_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""           "fix"
            ;;
          *)
            verbose_message  "az mysql ${server_type} update --name \"${mysql_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${set_value}\"" "fix"
            ;;
        esac
      fi
    else
      increment_secure   "${description} for MySQL ${server_type} DB \"${mysql_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
    fi
  fi
}
