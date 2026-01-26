#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_guest_users
#
# Check Azure Guest Users
#
# Refer to Section(s) 5.3.2 Page(s) 111-4 CIS Microsoft Azure Foundations Benchmark v5.0.0
#.

audit_azure_guest_users () {
  print_function "audit_azure_guest_users"
  verbose_message "Azure Guest Users" "check"
  guest_users=$( az ad user list --query "[?contains(userType, 'Guest')]" --query "id" -o tsv )
  if [ -z "$guest_users" ]; then
    increment_secure   "No guest users found"
  else
    increment_insecure "Guest users found: ${guest_users}"
  fi
}
