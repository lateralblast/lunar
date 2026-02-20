#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# check_azure_cosmos_db_value
#
# Check Azure Cosmos DB value
#
# This requires the Azure CLI to be installed and configured
#.

check_azure_cosmos_db_value () {
  description="${1}"
  cosmosdb_name="${2}"
  resource_group="${3}"
  query_string="${4}"
  function="${5}"
  correct_value="${6}"
  set_name="${7}"
  print_function  "check_azure_cosmos_db_value"
  verbose_message "${description} for Cosmos DB \"${cosmosdb_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\"" "check"
  command="az cosmosdb show --name \"${cosmosdb_name}\" --resource-group \"${resource_group}\" --query \"[].${query_string}\" --output tsv"
  command_message "${command}"
  actual_value=$( eval "${command}" )
  if [ "${function}" = "eq" ]; then
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_secure   "${description} for Cosmos DB \"${cosmosdb_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
    else
      increment_insecure "${description} for Cosmos DB \"${cosmosdb_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az cosmosdb update --name \"${cosmosdb_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\""           "fix"
            ;;
          *)
            verbose_message  "az cosmosdb update --name \"${cosmosdb_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${correct_value}\"" "fix"
            ;;
        esac
      fi
    fi
  else
    if [ "${actual_value}" = "${correct_value}" ]; then
      increment_insecure "${description} for Cosmos DB \"${cosmosdb_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is \"${function}\" to \"${correct_value}\""
      if [ ! "${set_name}" = "" ]; then
        case "${set_name}" in
          "--"*)
            verbose_message  "az cosmosdb update --name \"${cosmosdb_name}\" --resource-group \"${resource_group}\" ${set_name} \"${correct_value}\""           "fix"
            ;;
          *)
            verbose_message  "az cosmosdb update --name \"${cosmosdb_name}\" --resource-group \"${resource_group}\" --set \"${set_name}\"=\"\"${correct_value}\"" "fix"
            ;;
        esac
      fi
    else
      increment_secure   "${description} for Cosmos DB \"${cosmosdb_name}\" with Resource Group \"${resource_group}\" Parameter \"${query_string}\" is not \"${function}\" to \"${correct_value}\""
    fi
  fi
}
