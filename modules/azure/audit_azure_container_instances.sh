#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_container_instances
#
# Check Azure Container Instances
#
# 3.1  Ensure Private Virtual Networks are used for Container Instances - TBD
# 3.2  Ensure a Managed Identity is used for interactions with other Azure services - TBD
# 3.3  Ensure the principle of least privilege is used when assigning roles to a Managed Identity - TBD
#
# Refer to Section(s) 3.1- Page(s) 255- CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_container_instances () {
  print_function  "audit_azure_container_instances"
  check_message   "Azure Container Instances"
  command="az container list --query \"[].name\" --output tsv"
  command_message "${command}"
  c_list=$( eval  "${command}" 2> /dev/null )
  if [ -z "${c_list}" ]; then
    info_message  "No Container Instances found"
  fi
  for c_name in ${c_list}; do
    command="az container show --name \"${c_name}\" --query \"resourceGroup\" --output tsv"
    command_message   "${command}"
    res_group=$( eval "${command}" )
    check_azure_container_instance_value "Private Virtual Networks" "${c_name}" "${res_group}" "ipAddress.type" "eq" "Private"
    check_azure_container_instance_value "Managed Identity"         "${c_name}" "${res_group}" "identity.type"  "eq" "${azure_managed_identity}"
  done
}
