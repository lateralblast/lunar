#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_cosmos_db
#
# Check Azure Cosmos DB
#
# 3.1 Ensure That 'Firewalls & Networks' Is Limited to Use Selected Networks Instead of All Networks
# 3.2 Ensure that Cosmos DB uses Private Endpoints where possible
# 3.3 Ensure that 'disableLocalAuth' is set to 'true'
# 3.4 Ensure `Public Network Access` is `Disabled`
#
# Refer to Section(s) 3 Page(s) 11-12 Microsoft Azure Database Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_cosmos_db () {
  print_function  "audit_azure_cosmos_db"
  verbose_message "Azure Cosmos DB" "check"
  command="az cosmosdb list --query \"[].name\" --output tsv"
  command_message "${command}"
  cosmosdb_names=$( eval "${command}" )
  if [ -z "${cosmosdb_names}" ]; then
    verbose_message "No Cosmos DB instances found" "info"
    return
  fi
  for cosmosdb_name in ${cosmosdb_names}; do
    command="az cosmosdb show --name \"${cosmosdb_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    # 3.1 Ensure That 'Firewalls & Networks' Is Limited to Use Selected Networks Instead of All Networks
    check_cosmos_db_value "Firewalls & Networks Filter"   "${cosmosdb_name}" "${resource_group}" "isVirtualNetworkFilterEnabled" "eq" "true"     ""
    check_cosmos_db_value "Firewalls & Networks IP Rules" "${cosmosdb_name}" "${resource_group}" "ipRules"                       "ne" ""         ""
    # 3.2 Ensure that Cosmos DB uses Private Endpoints where possible
    check_cosmos_db_value "Private Endpoints"             "${cosmosdb_name}" "${resource_group}" "privateEndpointConnections"    "ne" ""         ""
    # 3.3 Ensure that 'disableLocalAuth' is set to 'true'
    check_cosmos_db_value "Disable Local Auth"            "${cosmosdb_name}" "${resource_group}" "disableLocalAuth"              "eq" "true"     "properties.disableLocalAuth"
    # 3.4 Ensure `Public Network Access` is `Disabled`
    check_cosmos_db_value "Public Network Access"         "${cosmosdb_name}" "${resource_group}" "publicNetworkAccess"           "eq" "Disabled" ""
  done
}
