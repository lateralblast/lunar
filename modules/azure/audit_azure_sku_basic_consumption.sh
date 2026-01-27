#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_sku_basic_consumption
#
# Check Azure SKU Basic/Consumption
#
# 6.1.5 Ensure that SKU Basic/Consumption is not used on artifacts that need to be monitored (Particularly for Production Workloads)
# Refer to Section(s) 6.1.5 Page(s) 281-3 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_sku_basic_consumption () {
  print_function  "audit_azure_sku_basic_consumption"
  verbose_message "Azure SKU Basic/Consumption" "check"
  resource_check="$( az graph query -q "Resources | where sku contains 'Basic' or sku contains 'consumption' | order by type" --query count --output tsv )"
  if [ "${resource_check}" -eq 0 ]; then
    increment_secure   "No resources that are being monitored are using SKU Basic/Consumption"
  else
    increment_insecure "Resources that are being monitored are using SKU Basic/Consumption"
  fi
}
