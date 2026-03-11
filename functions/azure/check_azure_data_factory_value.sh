#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_data_factory_value
#
# Check Azure Data Factory value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_data_factory_value () {
  description="${1}"
  data_factory_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  set_name="${7}"
  set_value="${8}"
  print_function "check_azure_data_factory_value"
  if [ "${set_value}" = "" ]; then
    set_value="${correct_value}"
  fi
  check_message "${description} for Data Factory \"${data_factory_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
  command="az datafactory show --name \"${data_factory_name}\" --resource-group \"${resource_group}\" --query \"[].${query_string}\" --output tsv"
  command_message      "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_secure   "${description} for Data Factory \"${data_factory_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      inc_insecure "${description} for Data Factory \"${data_factory_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            fix_message "az datafactory update --name \"${data_factory_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
            ;;
          *)
            fix_message "az datafactory update --name \"${data_factory_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${set_value}\""
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      inc_insecure "${description} for Data Factory \"${data_factory_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            fix_message "az datafactory update --name \"${data_factory_name}\" --resource-group \"${resource_group}\" ${set_name} \"${set_value}\""
            ;;
          *)
            fix_message "az datafactory update --name \"${data_factory_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${set_value}\""
            ;;
        esac
      fi
    else
      inc_secure  "${description} for Data Factory \"${data_factory_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
    fi
  fi
}
