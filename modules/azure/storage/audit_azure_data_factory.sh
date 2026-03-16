#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_data_factory
#
# Check Azure Data Factory
#
# 4.1 Ensure Data Factory is encrypted using Customer Managed Keys
# 4.2 Ensure Data Factory is using Managed Identities - TBD
# 4.3 Ensure that Data Factory is using Azure Key Vault to store Credentials and Secrets - TBD
# 4.4 Ensure that Data Factory is using RBAC to manage privilege assignment - TBD
#
# Refer to Section(s) 4 Page(s) 73- Microsoft Azure Database Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_data_factory () {
  print_function "audit_azure_data_factory"
  check_message  "Azure Data Factory"
  command="az datafactory list --query \"[].name\" --output tsv"
  command_message       "${command}"
  factory_names=$( eval "${command}" )
  if [ -z "${factory_names}" ]; then
    info_message "No Data Factory instances found"
    return
  fi
  for factory_name in ${factory_names}; do
    command="az datafactory show --name \"${factory_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message        "${command}"
    resource_group=$( eval "${command}" )
    # 4.1 Ensure Data Factory is encrypted using Customer Managed Keys
    check_data_factory_value   "Customer-Managed Keys" "${factory_name}" "${resource_group}" "keyVaultKeyUri"           "ne" ""                          ""
    # 4.2 Ensure Data Factory is using Managed Identities - TBD
    check_data_factory_value   "Managed Identities"    "${factory_name}" "${resource_group}" "identity.type"            "eq" "${azure_managed_identity}" ""
    # 4.3 Ensure that Data Factory is using Azure Key Vault to store Credentials and Secrets - TBD
    check_data_factory_value   "Using Azure Key Vault" "${factory_name}" "${resource_group}" "properties.type.baseUrl"  "ne" ""                          ""
    # 4.4 Ensure that Data Factory is using RBAC to manage privilege assignment - TBD
    for item in principalName principalId principalType roleDefinitionName scope; do
      check_data_factory_value "Using RBAC"            "${factory_name}" "${resource_group}" "[].${item}"               "ne" ""                          ""
    done
  done
}
