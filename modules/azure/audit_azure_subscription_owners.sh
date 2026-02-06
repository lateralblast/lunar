#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_subscription_owners
#
# Check Azure Subscription Owners
#
# 5.27  Ensure that there are no more than 3 members with the Subscription Owner role
#
# Refer to Section(s) 5.27 Page(s) 186-8 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.
audit_azure_subscription_owners () {
  print_function "audit_azure_subscription_owners"
  verbose_message "Azure Subscription Owners" "check"
  command="az account list --query \"[].id\" --output tsv"
  command_message "${command}"
  subscription_ids=$( eval "${command}" )
  max_owners="3"
  for subscription_id in ${subscription_ids}; do
    command="az role assignment list --role Owner --scope /subscriptions/${subscription_id} --query \"[].id\" --output tsv"
    command_message "${command}"
    role_owners=$( eval "${command}" )
    if [ -z "${role_owners}" ]; then
      increment_secure   "There are members with the Subscription Owner role"
    else
      owner_count=$( echo "${role_owners}" | wc -l )
      if [ "${owner_count}" -gt "${max_owners}" ]; then
        increment_insecure "There are more than ${max_owners} members with the Subscription Owner role"
      else
        increment_secure   "There are ${owner_count} members with the Subscription Owner role"
      fi
      role_assignment_ids=$( echo "${role_owners}" | tr '\n' ' ' )
      verbose_message    "az role assignment delete --ids \"${role_assignment_ids}\"" "fix"
    fi
  done
}