#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_resource_logging
#
# Check Azure Resource Logging
#
# 6.1.4    Ensure that Azure Monitor Resource Logging is Enabled for All Services that Support it
# Refer to Section(s) 6.1.4 Page(s) 275-80 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_resource_logging () {
  print_function  "audit_azure_resource_logging"
  verbose_message "Azure Resource Logging" "check"
  subscription_ids="$( az account show --query id --output tsv )"
  for subscription_id in $subscription_ids; do
    resource_ids="$( az resource list --subscription "${subscription_id}" --query "[].id" --output tsv )"
    for resource_id in $resource_ids; do
      resource_logging_check=$( az monitor diagnostic-settings list --subscription "${subscription_id}" --resource "${resource_id}" --output tsv )
      if [ -z "${resource_logging_check}" ]; then
        increment_secure   "Resource logging is enabled for ${resource_id}"
      else
        increment_insecure "Resource logging is not enabled for ${resource_id}"
      fi
    done
  done
}
