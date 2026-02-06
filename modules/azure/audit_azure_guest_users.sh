#!/bin/sh

# shellcheck disable=SC1090
# shellcheck disable=SC2034
# shellcheck disable=SC2154

# audit_azure_guest_users
#
# Check Azure Guest Users
#
# 5.3.2 Ensure that guest user access is restricted
#
# Refer to Section(s) 5.3.2 Page(s) 111-4 CIS Microsoft Azure Foundations Benchmark v5.0.0
#
# This requires the Azure CLI to be installed and configured
#.

audit_azure_guest_users () {
  print_function  "audit_azure_guest_users"
  verbose_message "Azure Guest Users" "check"
  command="az ad user list --query \"[?contains(userType, 'Guest')]\" --query \"id\" --output tsv"
  command_message "${command}"
  guest_users=$( eval "${command}" )
  if [ -z "$guest_users" ]; then
    increment_secure   "No guest users found"
  else
    increment_insecure "Guest users found: ${guest_users}"
  fi
}
