#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_databricks
#
# Check Azure Databricks workspaces
#
# 2.1.1  Ensure that Azure Databricks is deployed in a customer-managed virtual network (VNet)
# 2.1.2  Ensure that network security groups are configured for Databricks subnets
# 2.1.3  Ensure that traffic is encrypted between cluster worker nodes
# 2.1.4  Ensure that users and groups are synced from Microsoft Entra ID to Azure Databricks
# 2.1.5  Ensure that Unity Catalog is configured for Azure Databricks
# 2.1.6  Ensure that usage is restricted and expiry is enforced for Databricks personal access tokens
# 2.1.7  Ensure that diagnostic log delivery is configured for Azure Databricks
# 2.1.8  Ensure critical data in Azure Databricks is encrypted with customer-managed keys
# 2.1.9  Ensure 'No Public IP' is set to 'Enabled'
# 2.1.10 Ensure 'Allow Public Network Access' is set to 'Disabled'
# 2.1.11 Ensure private endpoints are used to access Azure Databricks workspaces
# Refer to Section(s) 2.1.1-11 Page(s) 27-62 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_databricks () {
  print_function  "audit_azure_databricks"
  verbose_message "Azure Databricks" "check"
  command="az databricks workspace list --query \"[].name\" --output tsv"
  command_message "${command}"
  workspace_list=$( eval "${command}" )
  for workspace_name in ${workspace_list}; do
    command="az databricks workspace list --query \"[?contains(name, '${workspace}')].[resourceGroup]\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    command="az databricks workspace list --query \"[?contains(name, '${workspace}')].[id]\" --output tsv"
    command_message "${command}"
    resource_id=$( eval "${command}" )
    # 2.1.1  Ensure that Azure Databricks is deployed in a customer-managed virtual network (VNet) - TBD
    # 2.1.2  Ensure that network security groups are configured for Databricks subnets - TBD
    # 2.1.3  Ensure that traffic is encrypted between cluster worker nodes - TBD
    # 2.1.4  Ensure that users and groups are synced from Microsoft Entra ID to Azure Databricks - TBD
    # 2.1.5  Ensure that Unity Catalog is configured for Azure Databricks
    # 2.1.6  Ensure that usage is restricted and expiry is enforced for Databricks personal access tokens - TBD
    # 2.1.7  Ensure that diagnostic log delivery is configured for Azure Databricks
    # 2.1.8  Ensure critical data in Azure Databricks is encrypted with customer-managed keys
    # 2.1.9  Ensure 'No Public IP' is set to 'Enabled'
    # 2.1.10 Ensure 'Allow Public Network Access' is set to 'Disabled'
    # 2.1.11 Ensure private endpoints are used to access Azure Databricks workspaces - Needs check of each endpoint
    check_azure_monitor_value    "Diagnostic Log Delivery"     "${workspace_name}" "${resource_id}"    "diagnostic-settings"               ""   "ne"                  ""                      ""
    check_azure_databricks_value "Customer Managed Keys"       "${workspace_name}" "${resource_group}" "encryption.keySource"              "eq" "Microsoft.KeyVault." ""
    check_azure_databricks_value "No Public IP"                "${workspace_name}" "${resource_group}" "parameters.enableNoPublicIp.value" "eq" "true"                "--enable-no-public-ip"
    check_azure_databricks_value "Allow Public Network Access" "${workspace_name}" "${resource_group}" "publicNetworkAccess"               "eq" "Disabled"            "--public-network-access"
    check_azure_databricks_value "Private Endpoints"           "${workspace_name}" "${resource_group}" "privateEndpointConnections"        "ne" ""                    ""
  done
}