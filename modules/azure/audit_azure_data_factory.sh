#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_data_factory
#
# Check Azure Data Factory
#
# 4.1 Ensure Data Factory is encrypted using Customer Managed Keys
#
# Refer to Section(s) 4 Page(s) 73- Microsoft Azure Database Services Benchmark v1.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_data_factory () {
  print_function  "audit_azure_data_factory"
  verbose_message "Azure Data Factory" "check"
  command="az datafactory list --query \"[].name\" --output tsv"
  command_message "${command}"
  data_factory_names=$( eval "${command}" )
  if [ -z "${data_factory_names}" ]; then
    verbose_message "No Data Factory instances found" "info"
    return
  fi
  for data_factory_name in ${data_factory_names}; do
    command="az datafactory show --name \"${data_factory_name}\" --query \"[].resourceGroup\" --output tsv"
    command_message "${command}"
    resource_group=$( eval "${command}" )
    # 4.1 Ensure Data Factory is encrypted using Customer Managed Keys
    check_data_factory_value "Customer-Managed Keys" "${data_factory_name}" "${resource_group}" "keyVaultKeyUri" "ne" "" ""
  done
}
