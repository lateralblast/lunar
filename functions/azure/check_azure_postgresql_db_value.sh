#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_postgresql_db_value
#
# Check Azure PostgreSQL DB value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_postgresql_db_value () {
  description="${1}"
  server_type="${2}"
  server_name="${3}"
  resource_group="${4}"
  db_name="${5}"
  query_string="${6}"
  function="${7}"
  correct_value="${8}"
  set_name="${9}"
  set_value="${10}"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  print_function  "check_azure_postgresql_db_value"
  if [ "${server_type}" = "server" ]; then
    header_string="${description} for PostgreSQL ${server_type} DB Server \"${server_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\""
    verbose_message "${header_string} is \"${function}\" to \"${correct_value}\"" "check"
    command="az postgresql ${server_type} show --name \"${server_name}\" --resource-group \"${resource_group}\" --query \"[].${query_string}\" --output tsv"
    command_message "${command}"
  else
    header_string="${description} for PostgreSQL ${server_type} DB \"${server_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\""
    verbose_message "${header_string} is \"${function}\" to \"${correct_value}\"" "check"
    command="az postgresql ${server_type} show --server-name \"${server_name}\" --resource-group \"${resource_group}\" --database-name \"${db_name}\" --query \"[].${query_string}\" --output tsv"
    command_message "${command}"
  fi
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${header_string} is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${header_string} is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az postgresql ${server_type} update --name \"${server_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""           "fix"
            ;;
          *)
            verbose_message  "az postgresql ${server_type} update --name \"${server_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${set_value}\"" "fix"
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "${header_string} is \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az postgresql ${server_type} update --name \"${server_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""           "fix"
            ;;
          *)
            verbose_message  "az postgresql ${server_type} update --name \"${server_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${set_value}\"" "fix"
            ;;
        esac
      fi
    else
      increment_secure   "${header_string} is not \"${function}\" to \"${correct_value}\""
    fi
  fi
}
