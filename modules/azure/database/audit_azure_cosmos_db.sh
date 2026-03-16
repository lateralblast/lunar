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
# 3.5 Ensure critical data is encrypted with customer-managed keys (CMK)
# 3.6 Ensure the firewall does not allow all network traffic
# 3.7 Ensure that Cosmos DB Logging is Enabled
#
# Refer to Section(s) 3 Page(s) 51-72 Microsoft Azure Database Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_cosmos_db () {
  print_function "audit_azure_cosmos_db"
  check_message  "Azure Cosmos DB"
  command="az cosmosdb list --query \"[].name\" --output tsv"
  command_message  "${command}"
  db_names=$( eval "${command}" )
  if [ -z "${db_names}" ]; then
    info_message "No Cosmos DB instances found"
    return
  fi
  for db_name in ${db_names}; do
    command="az cosmosdb show --name \"${db_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    # 3.1 Ensure That 'Firewalls & Networks' Is Limited to Use Selected Networks Instead of All Networks
    check_cosmos_db_value "Firewalls & Networks Filter"   "${db_name}" "${res_group}" "isVirtualNetworkFilterEnabled" "eq" "true"     ""                            ""
    check_cosmos_db_value "Firewalls & Networks IP Rules" "${db_name}" "${res_group}" "ipRules"                       "ne" ""         ""                            ""
    # 3.2 Ensure that Cosmos DB uses Private Endpoints where possible
    check_cosmos_db_value "Private Endpoints"             "${db_name}" "${res_group}" "privateEndpointConnections"    "ne" ""         ""                            ""
    # 3.3 Ensure that 'disableLocalAuth' is set to 'true'
    check_cosmos_db_value "Disable Local Auth"            "${db_name}" "${res_group}" "disableLocalAuth"              "eq" "true"     "properties.disableLocalAuth" ""
    # 3.4 Ensure `Public Network Access` is `Disabled`
    check_cosmos_db_value "Public Network Access"         "${db_name}" "${res_group}" "publicNetworkAccess"           "eq" "Disabled" ""                            ""
    # 3.5 Ensure critical data is encrypted with customer-managed keys (CMK)
    check_cosmos_db_value "Customer-Managed Keys"         "${db_name}" "${res_group}" "keyVaultKeyUri"                "ne" ""         ""                            ""
    # 3.6 Ensure the firewall does not allow all network traffic
    check_cosmos_db_value "Firewalls & Networks IP Rules" "${db_name}" "${res_group}" "ipRules"                       "ne" "0.0.0.0"  "--ip-range-filter"           "comma-separated-list-of-allowed-ip-addresses"
  done
  command="az cosmosdb list --query \"[].id\" --output tsv"
  command_message "${command}"
  res_ids=$( eval "${command}" )
  for res_id in ${res_ids}; do
    check_azure_monitoring_diagnostics_value "${res_id}"
  done
}
