#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_application_insights
#
# Check Azure Application Insights
#
# Refer to Section(s) 6.1.3.1 Page(s) 272-74 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_application_insights () {
  print_function  "audit_azure_application_insights"
  verbose_message "Azure Application Insights" "check"
  insights_check=$( az monitor app-insights list --subscription "${subscription_id}" --query "az monitor app-insights component show --query "[].{ID:appId, Name:name, Tenant:tenantId, Location:location, Provisioning_State:provisioningState}"" -o tsv )
    if [ -z "${insights_check}" ]; then
      increment_secure   "Application Insights is enabled"
    else
      increment_insecure "Application Insights is not enabled"
    fi 
}
