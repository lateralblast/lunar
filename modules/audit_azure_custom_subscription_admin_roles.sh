#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_custom_subscription_admin_roles
#
# Check Azure Custom Subscription Admin Roles
#
# Refer to Section(s) 5.23 Page(s) 174-6 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.
audit_azure_custom_subscription_admin_roles () {
  print_function "audit_azure_custom_subscription_admin_roles"
  verbose_message "Azure Custom Subscription Admin Roles" "check"
  correct_value=""
  actual_value=$( az role definition list --custom-role-only True | grep -iE "assignableScope|subscription" | grep "*" )
  if [ -z "${actual_value}" ]; then
    increment_secure   "No custom subscription administrator roles exist"
  else
    increment_insecure "Custom subscription administrator roles exist"
    verbose_message    "az role definition delete --name <role name>"
  fi
}