#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_elastic_san
#
# Check Azure Elastic SAN
#
# 2.2.1.1 Ensure public network access is Disabled
# 15.1    Ensure 'Public network access' is set to 'Disabled' on Azure Elastic SAN
# 15.2    Ensure customer-managed keys (CMK) are used to encrypt data at rest on Azure Elastic SAN volume groups
#
# Refer to Section(s) 2 Page(s) 25- CIS Microsoft Azure Storage Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_elastic_san () {
  print_function  "audit_azure_elastic_san"
  verbose_message "Azure Elastic SAN" "check"
  command="az elastic-san list --query \"[].id\" --output tsv"
  command_message "${command}"
  elastic_san_ids=$( eval "${command}" )
  for elastic_san_id in ${elastic_san_ids}; do
    # 2.2.1.1 Ensure public network access is Disabled
    # 15.1    Ensure 'Public network access' is set to 'Disabled' on Azure Elastic SAN
    check_azure_elastic_san_value "Public Network Access" "${elastic_san_id}" "" "" "" "" "publicNetworkAccess" "eq" "Disabled" "--public-network-access" ""
    # 15.2    Ensure customer-managed keys (CMK) are used to encrypt data at rest on Azure Elastic SAN volume groups
    command="az elastic-san show --id \"${elastic_san_id}\" --query \"[].resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    command="az elastic-san show --id \"${elastic_san_id}\" --query \"[].name\" --output tsv"
    command_message "${command}"
    elastic_san_name=$( eval "${command}" )
    command="az elastic-san volume-group list --resource-group \"${resource_group}\" --elastic-san \"${elastic_san_name}\" --query \"[].name\" --output tsv"
    volume_group_names=$( eval "${command}" )
    for volume_group_name in ${volume_group_names}; do
      check_azure_elastic_san_value "Customer Managed Keys" "" "${elastic_san_name}" "${resource_group}" "${volume_group_name}" "encryption" "eq" "EncryptionAtRestWithCustomerManagedKey" "" ""
    done 
  done
}
