#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_elastic_san
#
# Check Azure Elastic SAN
#
# 2.2.1.1 Ensure public network access is Disabled
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
  elastic_sans=$( eval "${command}" )
  for elastic_san in ${elastic_sans}; do
    # 2.2.1.1 Ensure public network access is Disabled
    check_azure_elastic_san_value "Public Network Access" "${elastic_san}" "publicNetworkAccess" "eq" "Disabled" "--public-network-access" ""
  done
}
