#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_app_service_ase
#
# Check Azure App Service ASE
#
# 2.6 Ensure App Service Environment is deployed with an internal load balancer
# 2.7 Ensure App Service Environment is provisioned with v3 or higher
# 2.8 Ensure App Service Environment has internal encryption enabled
#
# Refer to Section(s) 2.6-8 Page(s) 243-9 CIS Microsoft Azure Compute Services Benchmark v2.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_app_service_ase () {
  print_function  "audit_azure_app_service_ase"
  verbose_message "Azure App Service ASE" "check"
  command="az appservice ase list --query \"[].name\" --output tsv"
  command_message "${command}"
  ase_list=$( eval "${command}" 2> /dev/null )
  if [ -z "${ase_list}" ]; then
    info_message "No App Service ASE found"
  fi
  for ase_name in ${ase_list}; do
    check_azure_app_service_ase_value "Deployed with an internal load balancer"         "${ase_name}" ""                "internalLoadBalancingMode" "ne" "None"
    check_azure_app_service_ase_value "Provisioned with ${azure_ase_version} or higher" "${ase_name}" ""                "kind"                      "eq" "${azure_ase_version}"
    check_azure_app_service_ase_value "Internal encryption enabled"                     "${ase_name}" "clusterSettings" "internalEncryption"        "eq" "true"
  done
}
